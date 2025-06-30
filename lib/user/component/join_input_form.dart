import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mma_flutter/common/component/custom_text_form_field.dart';
import 'package:mma_flutter/common/component/input_label.dart';
import 'package:mma_flutter/common/component/input_vaiidator.dart';
import 'package:mma_flutter/user/provider/smtp_provider.dart';
import 'package:mma_flutter/user/provider/user_provider.dart';
import 'package:mma_flutter/user/repository/smtp_repository.dart';
import 'package:mma_flutter/user/screen/verification_screen.dart';

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
          InputLabel(title: '닉네임'),
          Row(
            children: [
              Expanded(
                child: CustomTextFormField(
                  onChanged: (val) {
                    nickname = val;
                  },
                  hintText: '사용하실 닉네임을 입력해주세요.',
                  validator: InputValidator.validator('닉네임'),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    if (nickname.trim().length < 2) {
                      setState(() {
                        nicknameCheckMessage = Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            alignment: Alignment.topLeft,
                            child: Text(
                              '닉네임의 최소 길이는 2입니다.',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        );
                      });
                      return;
                    }
                    print('nickname : $nickname');
                    final resp = await ref
                        .read(userProvider.notifier)
                        .checkDupNickname(nickname);
                    print('resp = $resp');
                    setState(() {
                      final message = resp ? '중복된 닉네임입니다.' : '사용 가능한 닉네임입니다.';
                      final color = resp ? Colors.red : Colors.blueAccent;
                      isNicknameNotDuplicated = resp ? false : true;
                      nicknameCheckMessage = Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Container(
                          alignment: Alignment.topLeft,
                          child: Text(message, style: TextStyle(color: color)),
                        ),
                      );
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Text('중복 확인'),
                ),
              ),
            ],
          ),
          if (nicknameCheckMessage != null) nicknameCheckMessage!,
          InputLabel(title: '이메일'),
          CustomTextFormField(
            onChanged: (val) {
              email = val;
            },
            hintText: 'example@fightweek.com',
            validator: InputValidator.validator('이메일'),
          ),
          InputLabel(title: '비밀번호'),
          CustomTextFormField(
            onChanged: (val) {
              password = val;
            },
            hintText: '********',
            validator: InputValidator.validator('비밀번호'),
          ),
          const SizedBox(height: 10),
          InputLabel(title: '비밀번호 확인'),
          CustomTextFormField(
            onChanged: (val) {
              passwordConfirm = val;
            },
            hintText: '********',
            validator: combineValidators([
              InputValidator.validator('비밀번호'),
              (String? value) =>
                  _validatePasswordConfirm(password, passwordConfirm),
            ]),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              minimumSize: Size.fromHeight(50),
              backgroundColor: Colors.green,
            ),
            onPressed:
                state == SmtpStatus.loading
                    ? null
                    : () async {
                      if (!isNicknameNotDuplicated) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('닉네임 중복 확인을 해주세요')),
                        );
                        return;
                      }

                      if (_formKey.currentState!.validate()) {
                        final res = await ref
                            .read(smtpProvider.notifier)
                            .sendJoinCode(email);
                        if (res) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder:
                                  (context) => VerificationScreen(
                                    email: email,
                                    nickname: nickname,
                                    password: password,
                                  ),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('중복된 이메일입니다.')),
                          );
                          return;
                        }
                      }
                    },
            child: Text(
              '회원가입',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          const SizedBox(height: 16),
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
