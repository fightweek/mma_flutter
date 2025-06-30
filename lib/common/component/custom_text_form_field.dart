import 'package:flutter/material.dart';
import 'package:mma_flutter/common/const/colors.dart';

class CustomTextFormField extends StatelessWidget {
  final String? hintText;
  final String? theme;
  final bool obscureText;
  final bool autofocus;
  final String? Function(String?)? validator;
  final double? borderSideWidth;
  final ValueChanged<String>? onChanged;
  final double? borderRadiusSize;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final double? height;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;

  const CustomTextFormField({
    required this.onChanged,
    this.obscureText = false,
    this.autofocus = false,
    this.borderSideWidth,
    this.borderRadiusSize,
    this.controller,
    this.hintText,
    this.theme,
    this.validator,
    this.suffixIcon,
    this.height,
    this.textStyle,
    this.padding,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final baseBorder = OutlineInputBorder(
      borderRadius:
          borderRadiusSize == null
              ? BorderRadius.zero
              : BorderRadius.circular(borderRadiusSize!),
      borderSide: BorderSide(width: borderSideWidth ?? 1.0),
    );
    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        style: textStyle ?? TextStyle(color: Colors.white),
        validator: validator,
        cursorColor: textStyle != null ? textStyle!.color : Colors.white,
        // 비밀번호 입력할 때
        obscureText: obscureText,
        autofocus: autofocus,
        onChanged: onChanged,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(height ?? 20.0),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey, fontSize: 14.0),
          fillColor: MY_DARK_GREY_COLOR,
          filled: true,
          border: baseBorder,
          // 텍스트 필드 선택 시 border 적용
          enabledBorder: baseBorder,
          focusedBorder: baseBorder.copyWith(
            borderSide: baseBorder.borderSide.copyWith(color: PRIMARY_COLOR),
          ),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
