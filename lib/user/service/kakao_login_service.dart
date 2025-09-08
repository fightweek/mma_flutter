import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:mma_flutter/user/enumtype/login_platform.dart';
import 'package:mma_flutter/user/model/naver_login_request.dart';

class KakaoLoginService {
  static Future<SocialLoginRequest> login() async {
    print('domain = ${ LoginPlatform.kakao.name.toUpperCase()}');
    bool isInstalled = await isKakaoTalkInstalled();
    final OAuthToken accessToken =
        isInstalled
            ? await UserApi.instance.loginWithKakaoTalk()
            : await UserApi.instance.loginWithKakaoAccount();
    final fcmToken = await FirebaseMessaging.instance.getToken();

    User user = await UserApi.instance.me();
    return SocialLoginRequest(
      domain: LoginPlatform.kakao.name.toUpperCase(),
      accessToken: accessToken.accessToken,
      email: user.kakaoAccount!.email!,
      socialId: user.id.toString(),
      fcmToken: fcmToken
    );
  }
}
