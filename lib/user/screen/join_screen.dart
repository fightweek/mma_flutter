import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mma_flutter/common/component/app_title.dart';
import 'package:mma_flutter/common/layout/default_layout.dart';
import 'package:mma_flutter/user/component/join_input_form.dart';
import 'package:mma_flutter/user/provider/smtp_provider.dart';
import 'package:mma_flutter/user/screen/login_screen.dart';

class JoinScreen extends ConsumerWidget {
  static String get routeName => '/join';

  const JoinScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(smtpProvider);
    if (state == SmtpStatus.error) {
      ref.read(smtpProvider.notifier).setStateNone();
      return LoginScreen();
    }
    return DefaultLayout(
      child: SizedBox.expand(
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 16),
              AppTitle(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  '회원가입',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 32,
                  ),
                ),
              ),
              JoinInputForm(),
            ],
          ),
        ),
      ),
    );
  }
}
