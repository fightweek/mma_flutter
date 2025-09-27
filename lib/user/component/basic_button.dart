import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mma_flutter/common/const/colors.dart';

class BasicButton extends StatelessWidget {
  final Color bgColor;
  final VoidCallback? onPressed;
  final String text;
  final Image? socialLoginIconImage;

  const BasicButton({
    required this.bgColor,
    required this.onPressed,
    required this.text,
    this.socialLoginIconImage,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 35.h,
      width: 302.w,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          disabledBackgroundColor: Color(0xff8c8c8c),
          backgroundColor: bgColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(8.r),
          ),
        ),
        child:
            socialLoginIconImage != null
                ? Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    socialLoginIconImage!,
                    SizedBox(width: 4.w),
                    _buttonText(),
                  ],
                )
                : Center(child: _buttonText()),
      ),
    );
  }

  Text _buttonText() {
    return Text(
      text,
      style: TextStyle(
        color: socialLoginIconImage != null ? BLACK_COLOR : WHITE_COLOR,
        fontSize: 12.sp,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
