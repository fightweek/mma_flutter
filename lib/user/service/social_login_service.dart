import 'package:mma_flutter/user/model/social_login_request.dart';

abstract class SocialLoginService{
  Future<SocialLoginRequest> login({required String? fcmToken});
}