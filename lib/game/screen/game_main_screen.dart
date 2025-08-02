import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mma_flutter/common/const/style.dart';
import 'package:mma_flutter/common/layout/default_layout.dart';

class GameMainScreen extends StatelessWidget {
  static String get routeName => 'game_main';

  const GameMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('게임 메인 화면'),);
  }
}
