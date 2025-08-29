import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/game/model/game_args.dart';
import 'package:mma_flutter/game/provider/game_provider.dart';

class GameEndScreen extends ConsumerStatefulWidget {
  static String get routeName => 'game_end';

  final bool isImage;
  final bool isNormal;

  const GameEndScreen({
    required this.isImage,
    required this.isNormal,
    super.key,
  });

  @override
  ConsumerState<GameEndScreen> createState() => _GameEndScreenState();
}

class _GameEndScreenState extends ConsumerState<GameEndScreen> {
  int correctCnt = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final count =
          await ref
              .read(
                gameProvider(
                  GameArgs(isNormal: widget.isNormal, isImage: widget.isImage),
                ).notifier,
              )
              .getCorrectCount();
      setState(() {
        correctCnt = count;
      });
    });
  }

  @override
  void dispose() {
    ref.invalidate(gameProvider(GameArgs(isNormal: widget.isNormal, isImage: widget.isImage)));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: PRIMARY_COLOR,
        title: Image.asset('asset/img/logo/fight_week.png', width: 50),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(child: Text('game end screen')),
          Center(child: Text('맞춘 횟수 : $correctCnt')),
          ElevatedButton(
            onPressed: () {
              context.go('/?tab=2');
            },
            child: Text('종료'),
          ),
        ],
      ),
    );
  }
}
