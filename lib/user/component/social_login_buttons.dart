import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/common/firebase/provider/fcm_token_provider.dart';
import 'package:mma_flutter/user/component/basic_button.dart';
import 'package:mma_flutter/user/enumtype/login_platform.dart';
import 'package:mma_flutter/user/model/social_login_request.dart';
import 'package:mma_flutter/user/model/user_model.dart';
import 'package:mma_flutter/user/provider/user_provider.dart';
import 'package:mma_flutter/user/service/google_login_service.dart';
import 'package:mma_flutter/user/service/kakao_login_service.dart';
import 'package:naver_login_sdk/naver_login_sdk.dart';

class SocialLoginButtons extends ConsumerWidget {
  const SocialLoginButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kakaoLoginService = ref.read(kakaoLoginServiceProvider);
    final googleLoginService = ref.read(googleLoginServiceProvider);
    final fcmTokenProvider = ref.read(firebaseFcmTokenProvider);

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
          onPressed: () async {
            ref
                .read(userProvider.notifier)
                .socialLogin(
                  request: await googleLoginService.login(
                    fcmToken: await fcmTokenProvider.getToken(),
                  ),
                );
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
          onPressed: () async {
            ref
                .read(userProvider.notifier)
                .socialLogin(
                  request: await kakaoLoginService.login(
                    fcmToken: await fcmTokenProvider.getToken(),
                  ),
                );
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
                          await ref.read(firebaseFcmTokenProvider).getToken();
                      NaverLoginSDK.profile(
                        callback: ProfileCallback(
                          onSuccess: (resultCode, message, response) {
                            final profile = NaverLoginProfile.fromJson(
                              response: response,
                            );
                            userNotifier.socialLogin(
                              request: SocialLoginRequest(
                                domain: LoginPlatform.naver.name.toUpperCase(),
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
