import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mma_flutter/common/component/app_image_with_text.dart';
import 'package:mma_flutter/common/component/auth_text_form_field.dart';
import 'package:mma_flutter/common/component/input_label.dart';
import 'package:mma_flutter/common/component/input_vaiidator.dart';
import 'package:mma_flutter/user/provider/smtp_provider.dart';
import 'package:mma_flutter/user/provider/user_provider.dart';
import 'package:mma_flutter/user/repository/smtp_repository.dart';

class JoinInputForm extends ConsumerStatefulWidget {
  const JoinInputForm({super.key});

  @override
  ConsumerState<JoinInputForm> createState() => _JoinInputFormState();
}

class _JoinInputFormState extends ConsumerState<JoinInputForm> {
  final _formKey = GlobalKey<FormState>();
  String nickname = '';
  String email = '';
  String password = '';
  String passwordConfirm = '';
  bool isNicknameNotDuplicated = false;
  Widget? nicknameCheckMessage;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(smtpProvider);
    return Form(
      key: _formKey,
      child: Column(
        children: [
        ],
      ),
    );
  }

  // string 타입을 반환하는 함수를 반환하는 함수
  String? Function(String?) combineValidators(
    List<String? Function(String?)> validators,
  ) {
    return (String? value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) {
          return result; // 첫번째로 에러나는 validator만 표시
        }
      }
      return null;
    };
  }

  String? _validatePasswordConfirm(String password, String passwordConfirm) {
    if (passwordConfirm.isEmpty) {
      return '비밀번호 확인칸을 입력하세요';
    } else if (password != passwordConfirm) {
      return '입력한 비밀번호가 서로 다릅니다.';
    } else {
      return null;
    }
  }
}
