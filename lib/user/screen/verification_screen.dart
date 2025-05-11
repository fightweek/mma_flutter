import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/common/layout/default_layout.dart';
import 'package:mma_flutter/user/model/verify_code_request.dart';
import 'package:mma_flutter/user/provider/smtp_provider.dart';
import 'package:mma_flutter/user/screen/login_screen.dart';

class VerificationScreen extends ConsumerStatefulWidget {
  final String email;
  final String nickname;
  final String password;

  const VerificationScreen({
    required this.email,
    required this.nickname,
    required this.password,
    super.key,
  });

  @override
  ConsumerState<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends ConsumerState<VerificationScreen> {
  final List<String> _code = List.filled(6, '');
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  @override
  void dispose() {
    for (final node in _focusNodes) {
      node.dispose();
    }
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Text(
              '인증번호를 입력하세요',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 30.0),
          Row(
            children:
                List.generate(
                  6,
                  (index) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        decoration: InputDecoration(
                          counterText: '',
                          // maxLength로 생기는 글자수 표시 없애기21
                          contentPadding: EdgeInsets.all(20),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 14.0,
                          ),
                          fillColor: BOX_COLOR,
                          filled: true,
                          // 텍스트 필드 선택 시 border 적용
                        ),
                        style: TextStyle(color: Colors.white),
                        onChanged: (value) {
                          if (value.length == 1) {
                            if (index < 5) {
                              _focusNodes[index + 1].requestFocus();
                            } else {
                              _focusNodes[index].unfocus();
                            }
                          }
                          setState(() {
                            _code[index] = value;
                          });
                        },
                      ),
                    ),
                  ),
                ).toList(),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () async {
              FocusManager.instance.primaryFocus?.unfocus();
              final res = await ref
                  .read(smtpProvider.notifier)
                  .verifyCode(
                    VerifyCodeRequest(
                      email: widget.email,
                      nickname: widget.nickname,
                      password: widget.password,
                      verifyingCode: _code.join(),
                    ),
                  );
              if (res == SmtpStatus.verified) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('성공'),
                      content: Text('회원가입 성공!'),
                      actions: [
                        ElevatedButton(
                          onPressed:
                              () => Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ),
                              ),
                          child: Text('로그인창으로 이동'),
                        ),
                      ],
                    );
                  },
                );
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('에러'),
                      content: Text('인증코드 오류'),
                      actions: [
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('닫기'),
                        ),
                      ],
                    );
                  },
                );
              }
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: BOX_COLOR,
              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text('입력 완료', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
