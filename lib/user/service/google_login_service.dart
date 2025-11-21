import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mma_flutter/user/enumtype/login_platform.dart';
import 'package:mma_flutter/user/model/social_login_request.dart';
import 'package:mma_flutter/user/service/social_login_service.dart';

final googleLoginServiceProvider = Provider<SocialLoginService>(
  (ref) => GoogleLoginService(),
);

class GoogleLoginService implements SocialLoginService {
  @override
  Future<SocialLoginRequest> login({required String? fcmToken}) async {
    final GoogleSignInAccount? user = await GoogleSignIn().signIn();
    if (user != null) {
      final GoogleSignInAuthentication googleAuth = await user.authentication;
      return SocialLoginRequest(
        domain: LoginPlatform.google.name.toUpperCase(),
        accessToken: googleAuth.accessToken!,
        email: user.email,
        socialId: user.id,
        fcmToken: fcmToken,
      );
    } else {
      throw Exception("구글 로그인 에러!");
    }
  }
}
