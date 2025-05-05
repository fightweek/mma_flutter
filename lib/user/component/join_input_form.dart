import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mma_flutter/common/component/custom_text_form_field.dart';
import 'package:mma_flutter/common/component/input_label.dart';
import 'package:mma_flutter/user/model/user_model.dart';
import 'package:mma_flutter/user/provider/user_provider.dart';

class JoinInputForm extends ConsumerStatefulWidget {
  const JoinInputForm({super.key});

  @override
  ConsumerState<JoinInputForm> createState() => _JoinInputFormState();
}

class _JoinInputFormState extends ConsumerState<JoinInputForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final userState = ref.read(userProvider);
    if (userState is UserModelError) {
      /**
       * Flutter의 build() 메서드는 위젯 트리 그리는 중간 단계
       * addPostFrameCallback는 build 다 끝나고 위젯 트리가 안정화되고 나서 실행됨
       */
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('에러'),
              content: Text(userState.message),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('닫기'),
                ),
              ],
            );
          },
        );
      });
    }
    bool isRemainLogin = false;
    String email = '';
    String password = '';
    return Form(
      key: _formKey,
      child: Column(
        children: [
          InputLabel(title: '이메일'),
          CustomTextFormField(
            onChanged: (val) {
              email = val;
            },
            hintText: 'example@fightweek.com',
            validator: validator('이메일'),
          ),
          InputLabel(title: '비밀번호'),
          CustomTextFormField(
            onChanged: (val) {
              password = val;
            },
            hintText: '********',
            validator: validator('비밀번호'),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              minimumSize: Size.fromHeight(50),
              backgroundColor: Colors.green,
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
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  FormFieldValidator<dynamic> validator(String theme) {
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
