import 'package:flutter/cupertino.dart';

class InputValidator {
  static String? Function(String?) validator(String theme) {
    return (value) {
      if (value == null || value.isEmpty) {
        return '$theme을 입력하세요';
      }
      if (theme == '이메일' && !value.contains('@')) {
        return '유효한 $theme 형식이 아닙니다';
      }
      return null;
    };
  }
}
