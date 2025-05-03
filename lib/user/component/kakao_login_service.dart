import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class KakaoLoginService {
  static Future<String> login() async {
    bool isInstalled = await isKakaoTalkInstalled();

    final OAuthToken accessToken =
        isInstalled
            ? await UserApi.instance.loginWithKakaoTalk()
            : await UserApi.instance.loginWithKakaoAccount();
    return accessToken.accessToken;
  }
}
