import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mma_flutter/common/const/style.dart';
import 'package:mma_flutter/fight_event/model/fight_event_model.dart';
import 'package:mma_flutter/game/model/image_game_questions_model.dart';
import 'package:mma_flutter/game/model/name_game_questions_model.dart';

class GameTextQuestion extends StatelessWidget {

  final NameGameQuestionModel? nameQuestionModel;
  final ImageGameQuestionModel? imageQuestionModel;

  const GameTextQuestion({
    required this.imageQuestionModel,
    required this.nameQuestionModel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final String question;
    if (nameQuestionModel != null) {
      if (nameQuestionModel!.gameCategory == GameCategory.headshot ||
          nameQuestionModel!.gameCategory == GameCategory.body) {
        question = '이 파이터의 이름은?';
      } else {
        if (nameQuestionModel!.gameCategory == GameCategory.nickname) {
          question =
              '다음 중 ${nameQuestionModel!.gameCategory.label}이\n \'${nameQuestionModel!.nickname!}\'인 파이터는?';
        } else if (nameQuestionModel!.gameCategory == GameCategory.ranking) {
          question =
              '다음 중 ${nameQuestionModel!.rankingCategory!} ${nameQuestionModel!.gameCategory.label}이\n ${nameQuestionModel!.ranking!}위인 파이터는?';
        } else {
          question =
              '다음 중 ${nameQuestionModel!.gameCategory.label}이\n ${_renderRecord(nameQuestionModel!.fightRecord!)}인 파이터는?';
        }
      }
    } else {
      question = imageQuestionModel!.name;
    }
    return SizedBox(
      height: 88.h,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset('asset/img/component/black.png'),
          Text(
            question,
            style: defaultTextStyle.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 24.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _renderRecord(FightRecordModel record) {
    return '${record.win}승 ${record.loss}패 ${record.draw}무';
  }

}
