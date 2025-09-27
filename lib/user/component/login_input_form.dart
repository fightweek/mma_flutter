import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mma_flutter/common/component/auth_text_form_field.dart';
import 'package:mma_flutter/common/component/input_vaiidator.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/user/provider/user_provider.dart';

class LoginInputForm extends ConsumerWidget {
  LoginInputForm({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String email = '';
    String password = '';
    return Form(
      key: _formKey,
      child: Column(
        children: [
          SizedBox(height: 26.h),
          AuthTextFormField(
            onChanged: (val) {
              email = val;
            },
            hintText: '이메일을 입력하세요',
            validator: InputValidator.validator('이메일'),
            borderRadiusSize: 8.r,
            borderSideWidth: 2.w,
          ),
          SizedBox(height: 11.h),
          AuthTextFormField(
            onChanged: (val) {
              password = val;
            },
            hintText: '비밀번호를 입력하세요',
            validator: InputValidator.validator('비밀번호'),
            borderRadiusSize: 8.r,
            borderSideWidth: 2.w,
            obscureText: true,
          ),
          SizedBox(height: 66.h),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              minimumSize: Size(270.w, 30.h),
              backgroundColor: BLUE_COLOR,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(8.r),
              ),
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                ref
                    .read(userProvider.notifier)
                    .login(email: email, password: password);
              }
            },
            child: Text(
              '로그인',
              style: TextStyle(
                fontSize: 12.sp,
                color: WHITE_COLOR,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
