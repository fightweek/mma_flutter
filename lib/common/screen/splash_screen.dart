import 'package:flutter/material.dart';
import 'package:mma_flutter/common/layout/default_layout.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  static String get routeName => 'splash';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'asset/img/logo/fight_week.png',
            width: MediaQuery.of(context).size.width / 2,
          ),
          const SizedBox(height: 16,),
          CircularProgressIndicator(color: Colors.white,),
        ],
      ),
    );
  }
}
