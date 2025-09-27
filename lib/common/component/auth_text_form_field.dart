import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/common/const/style.dart';

class AuthTextFormField extends StatelessWidget {
  final String? hintText;
  final bool obscureText;
  final bool autofocus;
  final String? Function(String?)? validator;
  final double? borderSideWidth;
  final ValueChanged<String>? onChanged;
  final double? borderRadiusSize;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final TextStyle? textStyle;
  final Color? borderSideColor;

  const AuthTextFormField({
    required this.onChanged,
    this.obscureText = false,
    this.autofocus = false,
    this.borderSideWidth,
    this.borderRadiusSize,
    this.controller,
    this.hintText,
    this.validator,
    this.suffixIcon,
    this.textStyle,
    this.borderSideColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final baseBorder = OutlineInputBorder(
      borderRadius:
          borderRadiusSize == null
              ? BorderRadius.zero
              : BorderRadius.circular(borderRadiusSize!),
      borderSide: BorderSide(
        width: borderSideWidth ?? 1.0,
        color: borderSideColor ?? GREY_COLOR,
      ),
    );
    return SizedBox(
      width: 302.w,
      child: TextFormField(
        controller: controller,
        style: textStyle ?? TextStyle(color: Colors.white, fontSize: 12.sp),
        validator: validator,
        cursorColor: textStyle != null ? textStyle!.color : Colors.white,
        // 비밀번호 입력할 때
        obscureText: obscureText,
        autofocus: autofocus,
        onChanged: onChanged,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.only(left: 16.w, bottom: 10.h, top: 10.h),
          hintText: hintText,
          hintStyle: TextStyle(
            color: GREY_COLOR,
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
          ),
          fillColor: BLACK_COLOR,
          filled: true,
          border: baseBorder,
          // 텍스트 필드 선택 시 border 적용
          enabledBorder: baseBorder,
          focusedBorder: baseBorder.copyWith(
            borderSide: baseBorder.borderSide.copyWith(
              color: borderSideColor ?? WHITE_COLOR
            ),
          ),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
