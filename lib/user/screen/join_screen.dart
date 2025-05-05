import 'package:flutter/material.dart';
import 'package:mma_flutter/common/component/app_title.dart';
import 'package:mma_flutter/common/layout/default_layout.dart';
import 'package:mma_flutter/user/component/join_input_form.dart';

class JoinScreen extends StatelessWidget {
  static String get routeName => '/join';
  const JoinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(child: Column(
      children: [
        const SizedBox(height: 50,),
        AppTitle(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text(
            '회원가입',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 40,
            ),
          ),
        ),
        JoinInputForm(),
      ],
    ));
  }
}
