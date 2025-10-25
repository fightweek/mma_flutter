import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/common/const/style.dart';
import 'package:mma_flutter/fight_event/component/fighter_fight_event_detail_stat.dart';
import 'package:mma_flutter/fight_event/model/fight_event_model.dart';
import 'package:mma_flutter/fight_event/model/fighter_fight_event_detail_model.dart';
import 'package:mma_flutter/stream/model/stream_fight_event_model.dart';

class FighterInfoScreen extends StatelessWidget {
  final FighterFightEventFighterModel f1;
  final FighterFightEventFighterModel f2;

  const FighterInfoScreen({required this.f1, required this.f2, super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: FighterFightEventDetailStat(winner: f1, loser: f2),
    );
  }
}
