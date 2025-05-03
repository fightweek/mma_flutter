import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:mma_flutter/common/const/data.dart';
import 'package:mma_flutter/common/provider/secure_storage_provider.dart';
import 'package:mma_flutter/user/component/kakao_login_service.dart';
import 'package:mma_flutter/user/model/login_request.dart';
import 'package:mma_flutter/user/model/naver_login_request.dart';
import 'package:mma_flutter/user/model/user_model.dart';
import 'package:mma_flutter/user/repository/auth_repository.dart';
import 'package:mma_flutter/user/repository/user_repository.dart';

final userProvider = StateNotifierProvider<UserStateNotifier, UserModelBase?>((
  ref,
) {
  final authRepository = ref.watch(authRepositoryProvider);
  final userRepository = ref.watch(userRepositoryProvider);
  final storage = ref.watch(secureStorageProvider);
  return UserStateNotifier(
    authRepository: authRepository,
    userRepository: userRepository,
    storage: storage,
  );
});

class UserStateNotifier extends StateNotifier<UserModelBase?> {
  final AuthRepository authRepository;
  final UserRepository userRepository;
  final FlutterSecureStorage storage;

  UserStateNotifier({
    required this.authRepository,
    required this.userRepository,
    required this.storage,
  }) : super(UserModelLoading()) {
    getMe();
  }

  void setStateLoading() {
    state = UserModelLoading();
  }

  void setStateNull() {
    state = null;
  }

  // 앱 시작 시 사용자 상태 확인 및 서버로부터 (최신) 정보 가져오는 것이 주목적
  Future<void> getMe() async {
    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);
    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);
    if (refreshToken == null || accessToken == null) {
      state = null;
      return;
    }
    final resp = await userRepository.getMe();
    state = resp;
  }

  Future<UserModelBase> kakaoLogin() async {
    try {
      state = UserModelLoading();
      final accessToken = await KakaoLoginService.login();
      User user = await UserApi.instance.me();
      print(accessToken.toString());
      final resp = await authRepository.socialLogin(
        request: SocialLoginRequest(
          domain: "KAKAO",
          accessToken: accessToken,
          email: user.kakaoAccount!.email!,
          socialId: user.id.toString(),
          nickname: user.kakaoAccount!.profile!.nickname!,
        ),
      );
      await storage.write(key: ACCESS_TOKEN_KEY, value: resp.accessToken);
      await storage.write(key: REFRESH_TOKEN_KEY, value: resp.refreshToken);
      final userResp = await userRepository.getMe();
      state = userResp;
      return userResp;
    } catch (e) {
      print('카카오 로그인 실패!, error = $e');
      state = UserModelError(message: '로그인 실패');
      return Future.value(state);
    }
  }

  Future<UserModelBase> naverLogin({
    required SocialLoginRequest request,
  }) async {
    try {
      state = UserModelLoading();
      final resp = await authRepository.socialLogin(request: request);
      await storage.write(key: ACCESS_TOKEN_KEY, value: resp.accessToken);
      await storage.write(key: REFRESH_TOKEN_KEY, value: resp.refreshToken);
      final userResp = await userRepository.getMe();
      state = userResp;
      return userResp;
    } catch (e) {
      state = UserModelError(message: '로그인 실패');
      return Future.value(state);
    }
  }

  Future<UserModelBase> login({
    required String email,
    required String password,
  }) async {
    try {
      state = UserModelLoading();
      final resp = await authRepository.login(
        request: LoginRequest(email: email, password: password),
      );
      await storage.write(key: ACCESS_TOKEN_KEY, value: resp.accessToken);
      await storage.write(key: REFRESH_TOKEN_KEY, value: resp.refreshToken);
      final userResp = await userRepository.getMe();
      state = userResp;
      return userResp;
    } catch (e) {
      state = UserModelError(message: '로그인 실패');
      return Future.value(state);
    }
  }

  Future<void> logout({bool withRefresh = true}) async {
    if (withRefresh) {
      await authRepository.logout();
    }
    state = null;
    await Future.wait([
      storage.delete(key: ACCESS_TOKEN_KEY),
      storage.delete(key: REFRESH_TOKEN_KEY),
    ]);
  }
}
