import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mma_flutter/common/const/data.dart';
import 'package:mma_flutter/common/firebase/provider/fcm_token_provider.dart';
import 'package:mma_flutter/common/provider/secure_storage_provider.dart';
import 'package:mma_flutter/user/model/join_request.dart';
import 'package:mma_flutter/user/model/login_request.dart';
import 'package:mma_flutter/user/model/social_login_request.dart';
import 'package:mma_flutter/user/model/user_model.dart';
import 'package:mma_flutter/user/repository/auth_repository.dart';
import 'package:mma_flutter/user/repository/user_repository.dart';

final userProvider = StateNotifierProvider<UserStateNotifier, UserModelBase?>((
  ref,
) {
  final authRepository = ref.read(authRepositoryProvider);
  final userRepository = ref.read(userRepositoryProvider);
  final storage = ref.read(secureStorageProvider);
  final fcmToken = ref.read(firebaseFcmTokenProvider);

  return UserStateNotifier(
    fcmTokenProvider: fcmToken,
    authRepository: authRepository,
    userRepository: userRepository,
    storage: storage,
  );
});

class UserStateNotifier extends StateNotifier<UserModelBase?> {
  final AuthRepository authRepository;
  final UserRepository userRepository;
  final FlutterSecureStorage storage;
  final FcmTokenProvider fcmTokenProvider;
  final bool autoFetch;

  UserStateNotifier({
    required this.authRepository,
    required this.userRepository,
    required this.storage,
    required this.fcmTokenProvider,
    this.autoFetch = true,
  }) : super(UserModelLoading()) {
    if (autoFetch) getMe();
  }

  void setStateLoading() {
    state = UserModelLoading();
  }

  void setStateNull() {
    state = null;
  }

  Future<bool> checkDupNickname(String nickname) {
    return userRepository.checkDuplicatedNickname(
      nickname: {'nickname': nickname},
    );
  }

  Future<void> updateNickname(String nickname) async {
    await userRepository.updateNickname(nickname: {'nickname': nickname});
    await getMe();
  }

  void updatePoint(int point) async {
    final currentState = state as UserModel;
    state = UserModel(
      point: point,
      role: currentState.role,
      id: currentState.id,
      nickname: currentState.nickname,
      email: currentState.email,
    );
  }

  // 앱 시작 시 사용자 상태 확인 및 서버로부터 (최신) 정보 가져오는 것이 주목적
  Future<void> getMe() async {
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);
    if (refreshToken == null || accessToken == null) {
      state = null;
      return;
    }
    try {
      final resp = await userRepository.getMe();
      if (resp.nickname == null) {
        state = UserModelNicknameSetting();
      } else {
        state = resp;
      }
    } on Exception {
      storage.delete(key: ACCESS_TOKEN_KEY);
      storage.delete(key: REFRESH_TOKEN_KEY);
      state = null;
    }
  }

  Future<void> login({required String email, required String password}) async {
    await handleExceptionWithHttpRequest(
      () async {
        final fcmToken = await fcmTokenProvider.getToken();
        state = UserModelLoadingToHome();
        final resp = await authRepository.login(
          request: LoginRequest(
            email: email,
            password: password,
            fcmToken: fcmToken,
          ),
        );
        await storage.write(key: ACCESS_TOKEN_KEY, value: resp.accessToken);
        await storage.write(key: REFRESH_TOKEN_KEY, value: resp.refreshToken);
        final userResp = await userRepository.getMe();
        state = userResp;
      },
      statusCode: 401,
      statusCodeErrorMessage: UserModelErrorMessage.invalidIdOrPassword.message,
      baseDioErrorMessage: UserModelErrorMessage.loginFailure.message,
    );
  }

  Future<void> socialLogin({required SocialLoginRequest request}) async {
    await handleExceptionWithHttpRequest(
      () async {
        state = UserModelLoadingToHome();
        final resp = await authRepository.socialLogin(request: request);
        await storage.write(key: ACCESS_TOKEN_KEY, value: resp.accessToken);
        await storage.write(key: REFRESH_TOKEN_KEY, value: resp.refreshToken);
        UserModel userResp = await userRepository.getMe();
        if (userResp.nickname == null) {
          state = UserModelNicknameSetting();
        } else {
          state = userResp;
        }
      },
      statusCode: 403,
      statusCodeErrorMessage:
          UserModelErrorMessage.duplicatedSocialAccountEmail.message,
      baseDioErrorMessage: UserModelErrorMessage.loginFailure.message,
    );
  }

  Future<void> join({required JoinRequest request}) async {
    await handleExceptionWithHttpRequest(
      () async {
        state = UserModelLoadingToHome();
        await userRepository.join(request: request);
      },
      statusCode: 400,
      statusCodeErrorMessage:
          UserModelErrorMessage.existsDuplicatedNicknameOrEmail.message,
      baseDioErrorMessage: UserModelErrorMessage.joinFailure.message,
    );
  }

  Future<void> logout({bool withRefresh = true}) async {
    if (withRefresh) {
      print('withRefresh');
      authRepository.logout();
    }
    state = null;
    await Future.wait([
      storage.delete(key: ACCESS_TOKEN_KEY),
      storage.delete(key: REFRESH_TOKEN_KEY),
    ]);
  }

  Future<void> handleExceptionWithHttpRequest(
    Future<void> Function() func, {
    int? statusCode,
    String? statusCodeErrorMessage,
    required String baseDioErrorMessage,
  }) async {
    try {
      await func();
    } on DioException catch (e) {
      if (statusCode != null && e.response?.statusCode == statusCode) {
        state = UserModelError(message: statusCodeErrorMessage!);
      } else {
        state = UserModelError(message: baseDioErrorMessage);
      }
    } on Exception {
      state = UserModelError(message: UserModelErrorMessage.unknown.message);
    }
  }
}

enum UserModelErrorMessage {
  invalidIdOrPassword('아이디 또는 비밀번호가 맞지 않습니다.\n다시 확인해주세요.'),
  duplicatedSocialAccountEmail('중복된 이메일 계정이 이미 존재합니다.\n다른 플랫폼으로 다시 로그인해주세요.'),
  existsDuplicatedNicknameOrEmail('중복된 닉네임/이메일 계정이 이미 존재합니다.'),
  loginFailure('로그인 실패'),
  joinFailure('회원가입 실패'),
  unknown('알 수 없는 오류 발생');

  final String message;

  const UserModelErrorMessage(this.message);
}
