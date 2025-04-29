import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mma_flutter/common/component/app_title.dart';
import 'package:mma_flutter/common/component/custom_text_form_field.dart';
import 'package:mma_flutter/common/layout/default_layout.dart';
import 'package:mma_flutter/user/provider/user_provider.dart';
import 'package:mma_flutter/user/screen/join_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static String get routeName => 'login';

  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  String email = '';
  String password = '';
  bool isRemainLogin = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(userProvider);

    return DefaultLayout(
      child: Column(
        children: [
          const SizedBox(height: 70),
          AppTitle(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Text(
              '로그인',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 40,
              ),
            ),
          ),
          Row(children: [_inputLabel('이메일')]),
          CustomTextFormField(
            onChanged: (val) {
              email = val;
            },
            hintText: 'example@fightweek.com',
          ),
          const SizedBox(height: 20),
          Row(children: [_inputLabel('비밀번호')]),
          CustomTextFormField(
            onChanged: (val) {
              password = val;
            },
            hintText: '********',
          ),
          Row(
            children: [
              Checkbox(
                value: isRemainLogin,
                onChanged: (value) {
                  setState(() {
                    isRemainLogin = value!;
                  });
                  print(isRemainLogin);
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
            onPressed: () async {
              print('email = $email, pwd = $password');
              ref
                  .read(userProvider.notifier)
                  .login(email: email, password: password);
            },
            child: Text(
              '로그인',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return JoinScreen();
                  },
                ),
              );
            },
            child: GestureDetector(
              onTap: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => JoinScreen()));
              },
              child: const Text(
                '계정이 없으신가요?',
                style: TextStyle(color: Colors.blueAccent),
              ),
            ),
          ),
          Expanded(child: SizedBox()),
          _SocialLogin(),
        ],
      ),
    );
  }

  Widget _inputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, bottom: 5),
      child: Text(label, style: TextStyle(color: Colors.white)),
    );
  }
}

class _SocialLogin extends StatelessWidget {
  const _SocialLogin();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50),
      child: Column(
        children: [
          Text(
            '------------------------소셜 로그인------------------------',
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset('asset/img/social/kakao.png', height: 45, width: 45),
              Image.asset('asset/img/social/naver.png', height: 45, width: 45),
              Image.asset('asset/img/social/google.png', height: 45, width: 45),
            ],
          ),
        ],
      ),
    );
  }
}
