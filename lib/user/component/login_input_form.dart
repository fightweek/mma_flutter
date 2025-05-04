import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mma_flutter/common/component/custom_text_form_field.dart';
import 'package:mma_flutter/user/model/user_model.dart';
import 'package:mma_flutter/user/provider/user_provider.dart';

class LoginInputForm extends ConsumerStatefulWidget {
  const LoginInputForm({super.key});

  @override
  ConsumerState<LoginInputForm> createState() => _LoginInputFormState();
}

class _LoginInputFormState extends ConsumerState<LoginInputForm> {
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
              content: Text('아이디 또는 비밀번호가 올바르지 않습니다'),
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
          _inputLabel('이메일'),
          CustomTextFormField(
            onChanged: (val) {
              email = val;
            },
            hintText: 'example@fightweek.com',
            validator: validator('이메일'),
          ),
          _inputLabel('비밀번호'),
          CustomTextFormField(
            onChanged: (val) {
              password = val;
            },
            hintText: '********',
            validator: validator('비밀번호'),
          ),
          Row(
            children: [
              Checkbox(
                value: isRemainLogin,
                onChanged: (value) {
                  setState(() {
                    isRemainLogin = value!;
                  });
                },
                activeColor: Color(0xFF6200EE),
              ),
              const Text('로그인 유지', style: TextStyle(color: Colors.white)),
              const SizedBox(width: 170),
              GestureDetector(
                onTap: () {
                  print('hello');
                },
                child: const Text(
                  '비밀번호 찾기',
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),
            ],
          ),
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

  Widget _inputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, bottom: 5),
      child: Container(
        alignment: Alignment.topLeft,
        child: Text(label, style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
