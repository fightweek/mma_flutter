import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:mma_flutter/user/enumtype/login_platform.dart';
import 'package:mma_flutter/user/model/social_login_request.dart';
import 'package:mma_flutter/user/service/social_login_service.dart';

final kakaoLoginServiceProvider = Provider<SocialLoginService>(
      (ref) => KakaoLoginService(),
);

class KakaoLoginService implements SocialLoginService {
  @override
  Future<SocialLoginRequest> login({required String? fcmToken}) async {
    bool isInstalled = await isKakaoTalkInstalled();
    final OAuthToken accessToken =
        isInstalled
            ? await UserApi.instance.loginWithKakaoTalk()
            : await UserApi.instance.loginWithKakaoAccount();

    User user = await UserApi.instance.me();
    return SocialLoginRequest(
      domain: LoginPlatform.kakao.name.toUpperCase(),
      accessToken: accessToken.accessToken,
      email: user.kakaoAccount!.email!,
      socialId: user.id.toString(),
      fcmToken: fcmToken,
    );
  }
}
