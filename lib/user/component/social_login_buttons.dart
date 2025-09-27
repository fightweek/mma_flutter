import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/user/component/basic_button.dart';
import 'package:mma_flutter/user/enumtype/login_platform.dart';
import 'package:mma_flutter/user/model/naver_login_request.dart';
import 'package:mma_flutter/user/model/user_model.dart';
import 'package:mma_flutter/user/provider/user_provider.dart';
import 'package:naver_login_sdk/naver_login_sdk.dart';

class SocialLoginButtons extends ConsumerWidget {
  const SocialLoginButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        _socialLoginButton(
          color: Color(0xffFFDC5D),
          socialLoginIconImage: Image.asset(
            'asset/img/social/kakao_logo.png',
            height: 16.h,
            width: 16.w,
          ),
          buttonText: '카카오로 시작하기',
          onPressed: () {
            ref
                .read(userProvider.notifier)
                .socialLogin(platform: LoginPlatform.kakao);
          },
        ),
        const SizedBox(height: 12),
        _naverLoginButton(ref: ref),
        const SizedBox(height: 12),
        _socialLoginButton(
          color: WHITE_COLOR,
          socialLoginIconImage: Image.asset(
            'asset/img/social/google_logo.png',
            height: 16.h,
            width: 16.w,
          ),
          buttonText: '구글로 시작하기',
          onPressed: () {
            ref
                .read(userProvider.notifier)
                .socialLogin(platform: LoginPlatform.google);
          },
        ),
      ],
    );
  }

  Widget _naverLoginButton({required WidgetRef ref}) {
    final userNotifier = ref.read(userProvider.notifier);
    final user = ref.watch(userProvider);
    final isLoading = user is UserModelLoading;

    return _socialLoginButton(
      color: Color(0xff05f140),
      socialLoginIconImage: Image.asset('asset/img/social/naver_logo.png'),
      buttonText: '네이버로 시작하기',
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
                      final accessToken = await NaverLoginSDK.getAccessToken();
                      final fcmToken =
                          await FirebaseMessaging.instance.getToken();
                      NaverLoginSDK.profile(
                        callback: ProfileCallback(
                          onSuccess: (resultCode, message, response) {
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
                                fcmToken: fcmToken,
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
    );
  }

  Widget _socialLoginButton({
    required Color color,
    required Image socialLoginIconImage,
    required String buttonText,
    VoidCallback? onPressed,
  }) {
    return BasicButton(
      bgColor: color,
      onPressed: onPressed!,
      text: buttonText,
      socialLoginIconImage: socialLoginIconImage,
    );
  }
}
