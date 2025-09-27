import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mma_flutter/common/component/app_image_with_text.dart';
import 'package:mma_flutter/common/component/custom_alert_dialog.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/common/layout/default_layout.dart';
import 'package:mma_flutter/user/component/social_login_buttons.dart';
import 'package:mma_flutter/user/model/user_model.dart';
import 'package:mma_flutter/user/provider/user_provider.dart';
import 'package:mma_flutter/user/screen/join/start_join_screen.dart';

import '../component/login_input_form.dart';

class LoginScreen extends ConsumerWidget {
  static String get routeName => 'login';

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.read(userProvider);
    if (userState is UserModelError) {
      /**
       * Flutter의 build() 메서드는 위젯 트리 그리는 중간 단계
       * addPostFrameCallback는 build 다 끝나고 위젯 트리가 안정화되고 나서 실행됨
       */
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (context) {
            return CustomAlertDialog(
              titleMsg: '로그인 실패',
              contentMsg: userState.message,
            );
          },
        );
      });
    }
    return DefaultLayout(
      child: SizedBox.expand(
        child: SingleChildScrollView(
          child: Column(
            children: [
              AppImageWithText(text: '로그인',),
              LoginInputForm(),
              SizedBox(
                width: 300.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _renderGestureLabel(label: '아이디 찾기', onTap: () {}),
                    _renderGestureLabel(label: '비밀번호 찾기', onTap: () {}),
                    _renderGestureLabel(
                      label: '회원가입',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => StartJoinScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50.h),
              SocialLoginButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _renderGestureLabel({
    required String label,
    required GestureTapCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12.sp,
          color: GREY_COLOR,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
