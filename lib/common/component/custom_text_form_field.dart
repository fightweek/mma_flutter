import 'package:flutter/material.dart';
import 'package:mma_flutter/common/const/colors.dart';

class CustomTextFormField extends StatelessWidget {
  final String? hintText;
  final String? errorText;
  final bool obscureText;
  final bool autofocus;
  final ValueChanged<String>? onChanged;

  const CustomTextFormField({required this.onChanged, this.obscureText = false, this.autofocus=false, this.hintText,this.errorText, super.key});

  @override
  Widget build(BuildContext context) {
    final baseBorder = OutlineInputBorder(
        borderSide: BorderSide(
          width: 1.0,
        )
    );
    return TextFormField(
      cursorColor: PRIMARY_COLOR,
      // 비밀번호 입력할 때
      obscureText: obscureText,
      autofocus: autofocus,
      onChanged: onChanged,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(20),
        hintText: hintText,
        errorText: errorText,
        hintStyle: TextStyle(
          color: Colors.grey,
          fontSize: 14.0,
        ),
        fillColor: Colors.white,
        filled: true,
        border: baseBorder,
        // 텍스트 필드 선택 시 border 적용
        enabledBorder: baseBorder,
        focusedBorder: baseBorder.copyWith(
            borderSide: baseBorder.borderSide.copyWith(
                color: PRIMARY_COLOR
            )
        ),
      ),
    );
  }
}
