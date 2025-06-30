import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mma_flutter/common/const/data.dart';
import 'package:mma_flutter/common/provider/secure_storage_provider.dart';
import 'package:mma_flutter/user/enumtype/login_platform.dart';
import 'package:mma_flutter/user/model/login_request.dart';
import 'package:mma_flutter/user/model/naver_login_request.dart';
import 'package:mma_flutter/user/model/user_model.dart';
import 'package:mma_flutter/user/repository/auth_repository.dart';
import 'package:mma_flutter/user/repository/user_repository.dart';
import 'package:mma_flutter/user/service/google_login_service.dart';
import 'package:mma_flutter/user/service/kakao_login_service.dart';

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

  Future<bool> checkDupNickname(String nickname) {
    return userRepository.checkDuplicatedNickname(
      nickname: {'nickname': nickname},
    );
  }

  Future<void> updateNickname(String nickname) async {
    await userRepository.updateNickname(nickname: {'nickname': nickname});
    await getMe();
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
    } on DioException catch (e) {
      storage.delete(key: ACCESS_TOKEN_KEY);
      storage.delete(key: REFRESH_TOKEN_KEY);
      state = null;
    }
  }

  Future<UserModelBase> join({
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

  Future<void> socialLogin({
    required LoginPlatform platform,
    SocialLoginRequest? request,
  }) async {
    try {
      state = UserModelLoading();
      if (platform == LoginPlatform.google) {
        request = await GoogleLoginService.login();
      } else if (platform == LoginPlatform.kakao) {
        request = await KakaoLoginService.login();
      }
      final resp = await authRepository.socialLogin(request: request!);
      print('accessToken=${resp.accessToken}');
      print('refreshToken=${resp.refreshToken}');
      await storage.write(key: ACCESS_TOKEN_KEY, value: resp.accessToken);
      await storage.write(key: REFRESH_TOKEN_KEY, value: resp.refreshToken);
      UserModel userResp = await userRepository.getMe();
      if (userResp.nickname == null) {
        state = UserModelNicknameSetting();
      } else {
        state = userResp;
      }
    } on DioException catch (e) {
      print('소셜 로그인 실패!, error = $e');
      if ((e.response?.statusCode!) == 403) {
        state = UserModelError(
          message: '중복된 이메일 계정이 이미 존재합니다.\n다른 플랫폼으로 다시 로그인해주세요.',
        );
      } else {
        state = UserModelError(message: '로그인 실패');
      }
    } on Exception catch (e) {
      state = UserModelError(message: '로그인 실패');
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
      print('withRefresh');
      authRepository.logout();
    }
    state = null;
    await Future.wait([
      storage.delete(key: ACCESS_TOKEN_KEY),
      storage.delete(key: REFRESH_TOKEN_KEY),
    ]);
  }
}
