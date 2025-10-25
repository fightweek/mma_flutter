import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mma_flutter/common/const/data.dart';
import 'package:mma_flutter/common/const/style.dart';
import 'package:mma_flutter/common/utils/data_utils.dart';
import 'package:mma_flutter/fight_event/component/fighter_fight_event_card.dart';
import 'package:mma_flutter/fight_event/component/stream_fighter_fight_event_card.dart';
import 'package:mma_flutter/fight_event/model/card_date_time_info_model.dart';
import 'package:mma_flutter/fight_event/model/fight_event_model.dart';
import 'package:mma_flutter/fight_event/model/abst/i_fight_event_model.dart';
import 'package:mma_flutter/fight_event/model/abst/i_fighter_fight_event_model.dart';
import 'package:mma_flutter/stream/model/stream_fight_event_model.dart';

class FightEventCardList extends StatelessWidget {
  final bool stream;
  final bool isFirstCardExcluded;
  final IFightEventModel ife;
  final List<bool>? checkBoxValues;
  final void Function(bool value, int index)? checkBoxOnChanged;

  const FightEventCardList({
    super.key,
    required this.ife,
    required this.stream,
    this.checkBoxValues,
    required this.isFirstCardExcluded,
    this.checkBoxOnChanged,
  });

  @override
  Widget build(BuildContext context) {
    IFightEventModel fe = ife;

    if (fe.mainCardDateTimeInfo == null || fe.prelimCardDateTimeInfo == null) {
      return Column(
        children:
            fe.fighterFightEvents
                .mapIndexed(
                  (index, ffe) =>
                      isFirstCardExcluded && index == 0
                          ? SizedBox.shrink()
                          : _buildCard(index: index, ffe: ffe),
                )
                .toList(),
      );
    }
    return Column(
      children: List.generate(fe.fighterFightEvents.length, (index) {
        final ffe = fe.fighterFightEvents[index];
        final header = _buildSequenceHeader(fe: fe, index: index);
        final cardSeqInfo = _resolveCardSequenceInfo(fe, index);

        return Column(
          children: [
            if (header != null) header,
            _buildCard(
              index: index,
              ffe: ffe,
              cardStartDateTimeInfo: cardSeqInfo.$1,
              whichCard: cardSeqInfo.$2,
            ),
          ],
        );
      }),
    );
  }

  Widget? _buildSequenceHeader({
    required IFightEventModel fe,
    required int index,
  }) {
    String? text;
    CardDateTimeInfoModel? info;

    if (index == 0) {
      text = '메인 카드';
      info = fe.mainCardDateTimeInfo;
    } else if (fe.mainCardCnt == index) {
      text = '언더 카드';
      info = fe.prelimCardDateTimeInfo;
    } else if (fe.earlyCardCnt != null &&
        fe.mainCardCnt! + fe.prelimCardCnt! == index) {
      text = '파이트 패스 언더 카드';
      info = fe.earlyCardDateTimeInfo;
    }

    if (text == null || info == null) return null;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Text(
        '$text (${DataUtils.formatDurationToHHMM(info.time)})',
        style: defaultTextStyle.copyWith(fontSize: 20.sp),
      ),
    );
  }

  (CardDateTimeInfoModel?, int?) _resolveCardSequenceInfo(
    IFightEventModel fe,
    int index,
  ) {
    if (index < fe.mainCardCnt!) {
      return (fe.mainCardDateTimeInfo, mainCard);
    } else if (fe.earlyCardDateTimeInfo != null &&
        fe.mainCardCnt! + fe.prelimCardCnt! <= index) {
      return (fe.earlyCardDateTimeInfo, earlyCard);
    } else {
      return (fe.prelimCardDateTimeInfo, prelimCard);
    }
  }

  Widget _buildCard({
    required int index,
    required IFighterFightEvent ffe,
    CardDateTimeInfoModel? cardStartDateTimeInfo,
    int? whichCard,
  }) {
    return stream
        ? StreamFighterFightEventCard(
          ffe: ffe as StreamFighterFightEventModel,
          upcoming: ffe.status == StreamFighterFightEventStatus.upcoming,
          checkboxValue: checkBoxValues![index],
          checkboxOnChanged: (value) {
            checkBoxOnChanged!.call(value!, index);
          },
        )
        : FighterFightEventCard(
          ffe: ffe as FighterFightEventModel,
          isFightEventCard: false,
          cardStartDateTimeInfo: cardStartDateTimeInfo,
          whichCard: whichCard,
        );
  }
}
