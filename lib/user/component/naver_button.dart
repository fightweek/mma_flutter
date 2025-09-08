import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mma_flutter/user/enumtype/login_platform.dart';
import 'package:mma_flutter/user/model/naver_login_request.dart';
import 'package:mma_flutter/user/model/user_model.dart';
import 'package:mma_flutter/user/provider/user_provider.dart';
import 'package:naver_login_sdk/naver_login_sdk.dart';
import 'package:flutter_logcat/flutter_logcat.dart';

class NaverButton extends ConsumerWidget {
  const NaverButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userNotifier = ref.read(userProvider.notifier);
    final user = ref.watch(userProvider);
    final isLoading = user is UserModelLoading;

    return NaverLoginButton(
      onPressed:
          isLoading
              ? () {
                print('button blocked for some reason!');
              }
              : () {
                userNotifier.setStateLoading();
                NaverLoginSDK.authenticate(
                  callback: OAuthLoginCallback(
                    onSuccess: () async {
                      Log.d('Naver login succeed');
                      final accessToken = await NaverLoginSDK.getAccessToken();
                      final fcmToken = await FirebaseMessaging.instance.getToken();
                      NaverLoginSDK.profile(
                        callback: ProfileCallback(
                          onSuccess: (resultCode, message, response) {
                            Log.i('Get naver profile...');
                            final profile = NaverLoginProfile.fromJson(
                              response: response,
                            );
                            userNotifier.socialLogin(
                              platform: LoginPlatform.naver,
                              request: SocialLoginRequest(
                                domain: "NAVER",
                                accessToken: accessToken,
                                email: profile.email!,
                                socialId: profile.id!,
                                fcmToken: fcmToken
                              ),
                            );
                          },
                        ),
                      );
                    },
                    onError: (errorCode, message) {
                      print('errorCode : $errorCode, message : $message');
                      userNotifier.setStateNull();
                    },
                    onFailure: (httpStatus, message) {
                      print('httpStatus : $httpStatus, message : $message');
                      userNotifier.setStateNull();
                    },
                  ),
                );
              },
      fit: BoxFit.cover,
      height: 50,
      width: MediaQuery.of(context).size.width/1.2,
      style: NaverLoginButtonStyle(
        mode: NaverButtonMode.white,
        type: NaverButtonType.rectangleBar,
        language: NaverButtonLanguage.korean,
      ),
    );
  }
}
