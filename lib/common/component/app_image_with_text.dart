import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mma_flutter/common/const/colors.dart';

class AppImageWithText extends StatelessWidget {
  final String text;

  const AppImageWithText({required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 90.h, bottom: 26.h),
          child: Image.asset(
            'asset/img/logo/fight_week_white.png',
            height: 57.h,
            width: 64.w,
          ),
        ),
        Text(
          text,
          style: TextStyle(
            color: WHITE_COLOR,
            fontWeight: FontWeight.w700,
            fontSize: 17.sp,
          ),
        ),
      ],
    );
  }
}
