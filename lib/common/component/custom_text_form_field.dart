import 'package:flutter/material.dart';
import 'package:mma_flutter/common/const/colors.dart';

class CustomTextFormField extends StatelessWidget {
  final String? hintText;
  final String? theme;
  final bool obscureText;
  final bool autofocus;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;

  const CustomTextFormField({
    required this.onChanged,
    this.obscureText = false,
    this.autofocus = false,
    this.hintText,
    this.theme,
    this.validator,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final baseBorder = OutlineInputBorder(borderSide: BorderSide(width: 1.0));
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        style: TextStyle(
          color: Colors.white,
        ),
        validator: validator,
        cursorColor: Colors.white,
        // 비밀번호 입력할 때
        obscureText: obscureText,
        autofocus: autofocus,
        onChanged: onChanged,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(20),
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
        ),
      ),
    );
  }
}
