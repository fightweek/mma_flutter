class InputValidator {
  static String? Function(String?) validator(String theme) {
    final themeMinLengthMap = {'닉네임': 2, '비밀번호': 6};

    return (value) {
      if (value == null || value.isEmpty) {
        return '$theme을 입력하세요';
      }
      if (theme == '이메일') {
        String pattern =
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
        RegExp regExp = RegExp(pattern);
        if (!regExp.hasMatch(value)) {
          return '잘못된 이메일 형식입니다.';
        } else {
          return null;
        }
      }
      if (value.trim().length < themeMinLengthMap[theme]!) {
        return '$theme은 최소 길이는 ${themeMinLengthMap[theme]}입니다';
      }
      return null;
    };
  }
}
