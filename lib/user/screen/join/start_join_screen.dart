import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mma_flutter/common/component/app_image_with_text.dart';
import 'package:mma_flutter/common/component/auth_text_form_field.dart';
import 'package:mma_flutter/common/component/input_vaiidator.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/common/layout/default_layout.dart';
import 'package:mma_flutter/user/provider/smtp_provider.dart';
import 'package:mma_flutter/user/screen/login_screen.dart';
import 'package:mma_flutter/user/screen/join/verification_screen.dart';

class StartJoinScreen extends ConsumerStatefulWidget {
  static String get routeName => '/join';

  const StartJoinScreen({super.key});

  @override
  ConsumerState<StartJoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends ConsumerState<StartJoinScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  bool isEmailDup = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(smtpProvider);

    return DefaultLayout(
      child: Center(
        child: SizedBox(
          width: 266.w,
          child: Column(
            children: [
              AppImageWithText(text: '회원가입'),
              SizedBox(height: 37.h),
              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  '이메일 주소*',
                  style: TextStyle(color: Color(0xff8c8c8c), fontSize: 12.sp),
                ),
              ),
              SizedBox(height: 5.h),
              Form(
                key: _formKey,
                child: AuthTextFormField(
                  onChanged: (val) {
                    /// 인증코드 전송 함수 활성화(backGround color)해야 하므로, setState 필요함
                    setState(() {
                      email = val;
                      isEmailDup = false;
                    });
                    _formKey.currentState!.validate();
                  },
                  hintText: '예) fightweek@example.com',
                  borderSideWidth: 2.w,
                  borderRadiusSize: 8.r,
                  validator:
                      isEmailDup == false
                          ? InputValidator.validator('이메일')
                          : InputValidator.validator('중복된 이메일'),
                ),
              ),
              SizedBox(height: 12.h),
              SizedBox(
                height: 34.h,
                width: 266.w,
                child: ElevatedButton(
                  onPressed:
                      (email.isEmpty ||
                              !(_formKey.currentState!.validate()) ||
                              state == SmtpStatus.loading)
                          ? null
                          : () async {
                            if (_formKey.currentState!.validate()) {
                              final res = await ref
                                  .read(smtpProvider.notifier)
                                  .sendJoinCode(email);
                              if (res) {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder:
                                        (context) =>
                                            VerificationScreen(email: email),
                                  ),
                                );
                              } else {
                                if (state == SmtpStatus.error) {
                                  Navigator.of(context).pop();
                                } else {
                                  setState(() {
                                    isEmailDup = true;
                                  });
                                  WidgetsBinding.instance.addPostFrameCallback((
                                    _,
                                  ) {
                                    _formKey.currentState!.validate();
                                  });
                                }
                              }
                            }
                          },
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(
                      color:
                          email.isEmpty || !_formKey.currentState!.validate()
                              ? GREY_COLOR
                              : WHITE_COLOR,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(8.r),
                    ),
                    backgroundColor: DARK_GREY_COLOR,
                  ),
                  child:
                      state == SmtpStatus.loading
                          ? SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: WHITE_COLOR,
                            ),
                          )
                          : Text(
                            '인증메일 전송',
                            style: TextStyle(
                              color:
                                  email.isEmpty ||
                                          !_formKey.currentState!.validate()
                                      ? GREY_COLOR
                                      : WHITE_COLOR,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
