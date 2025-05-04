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
          LoginInputForm(),
          GestureDetector(
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
          _SocialLogin(),
        ],
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
            ref.read(userProvider.notifier).socialLogin(LoginPlatform.kakao);
          },
          child: Image.asset(
            'asset/img/social/kakao_comp.png',
            height: 50,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 20),
        InkWell(
          onTap: () {
            ref.read(userProvider.notifier).socialLogin(LoginPlatform.google);
          },
          child: Image.asset(
            'asset/img/social/google_comp.png',
            height: 50,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 20),
        NaverButton(),
      ],
    );
  }
}
