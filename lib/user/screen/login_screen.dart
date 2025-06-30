import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mma_flutter/common/component/app_title.dart';
import 'package:mma_flutter/common/layout/default_layout.dart';
import 'package:mma_flutter/user/component/naver_button.dart';
import 'package:mma_flutter/user/enumtype/login_platform.dart';
import 'package:mma_flutter/user/provider/user_provider.dart';
import 'package:mma_flutter/user/screen/join_screen.dart';

import '../component/login_input_form.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static String get routeName => 'login';

  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: SizedBox.expand(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),
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
              LoginInputForm(),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: Size.fromHeight(50),
                  backgroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (context) => JoinScreen()));
                },
                child: Text('회원가입', style: TextStyle(fontSize: 20)),
              ),
              GestureDetector(
                onTap: () {
                  print('hello');
                },
                child: const Text(
                  '아이디/비밀번호 찾기 >',
                  style: TextStyle(
                    color: Colors.blueAccent,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 50),
              _SocialLogin(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialLogin extends ConsumerWidget {
  const _SocialLogin();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            ref
                .read(userProvider.notifier)
                .socialLogin(platform: LoginPlatform.kakao);
          },
          child: Image.asset(
            'asset/img/social/kakao_comp.png',
            height: 30,
            width: MediaQuery.of(context).size.width / 1.2,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () {
            ref
                .read(userProvider.notifier)
                .socialLogin(platform: LoginPlatform.google);
          },
          child: Image.asset(
            'asset/img/social/google_comp.png',
            height: 30,
            width: MediaQuery.of(context).size.width / 1.2,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 12),
        NaverButton(),
      ],
    );
  }
}
