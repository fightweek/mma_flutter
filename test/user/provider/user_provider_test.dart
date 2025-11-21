import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mma_flutter/common/firebase/provider/fcm_token_provider.dart';
import 'package:mma_flutter/user/model/join_request.dart';
import 'package:mma_flutter/user/model/login_request.dart';
import 'package:mma_flutter/user/model/login_response.dart';
import 'package:mma_flutter/user/model/social_login_request.dart';
import 'package:mma_flutter/user/model/user_model.dart';
import 'package:mma_flutter/user/provider/user_provider.dart';
import 'package:mma_flutter/user/repository/auth_repository.dart';
import 'package:mma_flutter/user/repository/user_repository.dart';
import 'package:mocktail/mocktail.dart';

class _MockUserRepo extends Mock implements UserRepository {}

class _MockAuthRepo extends Mock implements AuthRepository {}

class _MockSecureStorage extends Mock implements FlutterSecureStorage {}

class _MockFcmTokenProvider extends Mock implements FcmTokenProvider {}

/**
 * ※ getMe()
 * 1. userRepo로부터 getMe() 호출 시 닉네임 포함된 값을 받을 경우, state UserModel 세팅 여부 확인
 * 2. userRepo로부터 받은 user 정보의 닉네임이 null인 경우, state UserModelNicknameSetting 세팅 여부 확인
 * 3. 예외 발생 시, state null (state null -> login screen redirect) 세팅 여부 확인
 * ※ login()
 * 1. authRepo의 login() 호출 전 UserModelLoadingToHome 상태 확인, 성공 시 state UserModel 세팅 여부 확인
 * 2. 401 예외 발생 시, 상태 UserModelError 세팅 여부 및 메시지 확인
 * ※ socialLogin()
 * 1. authRepo의 socialLogin() 호출 전 UserModelLoadingToHome 상태 확인, 성공 시 state UserModel 세팅 여부 확인
 * 2. userRepo로부터 받은 user 정보의 닉네임이 null인 경우, state UserModelNicknameSetting 세팅 여부 확인
 * 3. 403 예외 발생 시, 상태 UserModelError 세팅 여부 및 메시지 확인
 * 4. 그 외 예외 발생 시, 상태 UserModelError 세팅 여부 및 메시지 확인
 * ※ join()
 * 1. userRepos의 join() 호출 직전, UserModelLoadingToHome 상태 확인 및 성공 시 userProvider의 login() 로직 수행 확인
 * 2. 400 예외 발생 시, UserModelError 세팅 여부 및 메시지 확인
 * 3. 그 외 예외 발생 시, 상태 UserModelError 세팅 여부 및 메시지 확인
 *
 */

void main() {
  late _MockAuthRepo authRepo;
  late _MockUserRepo userRepo;
  late _MockSecureStorage mockStorage;
  late ProviderContainer container;
  late UserStateNotifier userStateNotifier;
  late FcmTokenProvider mockFcmTokenProvider;
  late UserModel userModel;
  late UserModel userModelWithoutNickname;

  setUp(() {
    userModel = UserModel(
      point: 1000,
      role: 'ROLE_USER',
      id: 10,
      nickname: 'nickname',
      email: 'email@google.com',
    );
    userModelWithoutNickname = UserModel(
      point: userModel.point,
      role: userModel.role,
      id: userModel.id,
      nickname: null,
      email: userModel.email,
    );
    authRepo = _MockAuthRepo();
    userRepo = _MockUserRepo();
    mockStorage = _MockSecureStorage();
    mockFcmTokenProvider = _MockFcmTokenProvider();
    container = ProviderContainer(
      overrides: [
        userProvider.overrideWith((ref) {
          return UserStateNotifier(
            authRepository: authRepo,
            userRepository: userRepo,
            storage: mockStorage,
            fcmTokenProvider: mockFcmTokenProvider,
            autoFetch: false,
          );
        }),
      ],
    );
    userStateNotifier = container.read(userProvider.notifier);
    when(
      () => mockStorage.read(key: any(named: 'key')),
    ).thenAnswer((_) async => 'storage-key');
    when(() => userRepo.getMe()).thenAnswer((_) async => userModel);
  });

  test(
    'getMe() success case1 (when nickname is not null, then state equals resp)',
    () async {
      // when
      await userStateNotifier.getMe();

      // then
      final expectedUserModel = container.read(userProvider);
      expect(expectedUserModel, equals(userModel));
    },
  );

  test(
    'getMe() success case2 (when nickname is null, then state is UserModelNicknameSetting)',
    () async {
      // given
      when(
        () => userRepo.getMe(),
      ).thenAnswer((_) async => userModelWithoutNickname);

      // when
      await userStateNotifier.getMe();

      // then
      final expectedUserModel = container.read(userProvider);
      expect(expectedUserModel, isA<UserModelNicknameSetting>());
    },
  );

  test(
    'getMe() exception case (when getMe() throws an exception, then state is null)',
    () async {
      // given
      when(
        () => userRepo.getMe(),
      ).thenThrow(DioException(requestOptions: RequestOptions()));
      when(
        () => mockStorage.delete(key: any(named: 'key')),
      ).thenAnswer((_) async {});

      // when
      await userStateNotifier.getMe();

      // then
      final expectedUserModel = container.read(userProvider);
      expect(expectedUserModel, null);
    },
  );

  test('login() success case', () async {
    // given
    registerFallbackValue(
      LoginRequest(email: 'e', password: 'p', fcmToken: 't'),
    );
    when(
      () => mockFcmTokenProvider.getToken(),
    ).thenAnswer((_) async => 'token');
    when(() => authRepo.login(request: any(named: 'request'))).thenAnswer(
      (_) async =>
          LoginResponse(refreshToken: 'refresh', accessToken: 'access'),
    );
    when(
      () =>
          mockStorage.write(key: any(named: 'key'), value: any(named: 'value')),
    ).thenAnswer((_) async {});

    // when
    await userStateNotifier.login(email: userModel.email, password: 'pwd123');

    // then
    final expectedUserModel = container.read(userProvider);
    expect(expectedUserModel, equals(userModel));
  });

  test(
    'login() exception case (when login() throws an 401 exception, then state is UserModelError'
    ' with invalidIdOrPassword message',
    () async {
      // given
      registerFallbackValue(
        LoginRequest(email: 'e', password: 'p', fcmToken: 't'),
      );
      when(
        () => mockFcmTokenProvider.getToken(),
      ).thenAnswer((_) async => 'token');
      final requestOptions = RequestOptions();
      when(() => authRepo.login(request: any(named: 'request'))).thenThrow(
        DioException(
          requestOptions: requestOptions,
          response: Response(statusCode: 401, requestOptions: requestOptions),
        ),
      );

      // when
      await userStateNotifier.login(email: userModel.email, password: 'pwd123');

      // then
      final expectedUserModel = container.read(userProvider);
      expect(
        (expectedUserModel as UserModelError).message,
        equals(UserModelErrorMessage.invalidIdOrPassword.message),
      );
    },
  );

  test('socialLogin() success case1', () async {
    // given
    final socialLoginRequest = SocialLoginRequest(
      domain: 'domain123',
      accessToken: 'access123',
      email: 'email123',
      socialId: 'socialId123',
      fcmToken: 'token123',
    );
    registerFallbackValue(socialLoginRequest);
    when(() => authRepo.socialLogin(request: any(named: 'request'))).thenAnswer(
      (_) async =>
          LoginResponse(refreshToken: 'refresh', accessToken: 'access'),
    );
    when(
      () =>
          mockStorage.write(key: any(named: 'key'), value: any(named: 'value')),
    ).thenAnswer((_) async {});

    final userStateHistory = <UserModelBase?>[];
    userStateNotifier.addListener((state) {
      userStateHistory.add(state);
    });
  });

  test(
    'socialLogin() success case2 (when nickname is null, then state is UserModelNicknameSetting)',
    () async {
      // given
      final socialLoginRequest = SocialLoginRequest(
        domain: 'domain123',
        accessToken: 'access123',
        email: 'email123',
        socialId: 'socialId123',
        fcmToken: 'token123',
      );
      registerFallbackValue(socialLoginRequest);
      when(
        () => authRepo.socialLogin(request: any(named: 'request')),
      ).thenAnswer(
        (_) async =>
            LoginResponse(refreshToken: 'refresh', accessToken: 'access'),
      );
      when(
        () => mockStorage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) async {});
      when(
        () => userRepo.getMe(),
      ).thenAnswer((_) async => userModelWithoutNickname);

      final userStateHistory = <UserModelBase?>[];
      userStateNotifier.addListener((state) {
        userStateHistory.add(state);
      });

      // when
      await userStateNotifier.socialLogin(request: socialLoginRequest);

      // then
      final expectedUserModel = container.read(userProvider);
      expect(expectedUserModel, isA<UserModelNicknameSetting>());
    },
  );

  test(
    'socialLogin() exception case (when socialLogin() throws an 401 exception, then state is UserModelError)',
    () async {
      // given
      final socialLoginRequest = SocialLoginRequest(
        domain: 'domain123',
        accessToken: 'access123',
        email: 'email123',
        socialId: 'socialId123',
        fcmToken: 'token123',
      );
      registerFallbackValue(socialLoginRequest);
      final requestOptions = RequestOptions();
      when(
        () => authRepo.socialLogin(request: any(named: 'request')),
      ).thenThrow(
        DioException(
          requestOptions: requestOptions,
          response: Response(statusCode: 403, requestOptions: requestOptions),
        ),
      );

      // when
      await userStateNotifier.socialLogin(request: socialLoginRequest);

      // then
      final expectedUserModel = container.read(userProvider);
      expect(
        (expectedUserModel as UserModelError).message,
        equals(UserModelErrorMessage.duplicatedSocialAccountEmail.message),
      );
    },
  );

  test('join() success case', () async {
    // given
    final joinRequest = JoinRequest(
      email: 'email',
      nickname: 'nickname',
      password: 'pwd123',
    );
    registerFallbackValue(joinRequest);
    when(
      () => userRepo.join(request: any(named: 'request')),
    ).thenAnswer((_) async {});

    // when
    await userStateNotifier.join(request: joinRequest);

    // then
    final expectedUserModel = container.read(userProvider);
    expect(expectedUserModel, isA<UserModelLoadingToHome>());
  });

  test(
    'join() exception case (when join() throws an 400 exception, then state is UserModelError)',
    () async {
      // given
      final joinRequest = JoinRequest(
        email: 'email',
        nickname: 'nickname',
        password: 'pwd123',
      );
      registerFallbackValue(joinRequest);
      final requestOptions = RequestOptions();
      when(() => userRepo.join(request: any(named: 'request'))).thenThrow(
        DioException(
          requestOptions: requestOptions,
          response: Response(statusCode: 400, requestOptions: requestOptions),
        ),
      );

      // when
      await userStateNotifier.join(request: joinRequest);

      // then
      final expectedUserModel = container.read(userProvider);
      expect(
        (expectedUserModel as UserModelError).message,
        equals(UserModelErrorMessage.existsDuplicatedNicknameOrEmail.message),
      );
    },
  );
}
