import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mma_flutter/common/const/style.dart';
import 'package:mma_flutter/common/utils/data_utils.dart';
import 'package:mma_flutter/fight_event/component/fight_event_card.dart';
import 'package:mma_flutter/fight_event/component/stream_fight_event_card.dart';
import 'package:mma_flutter/fight_event/model/fight_event_model.dart';
import 'package:mma_flutter/fight_event/model/i_fight_event_model.dart';
import 'package:mma_flutter/fight_event/model/i_fighter_fight_event_model.dart';
import 'package:mma_flutter/stream/model/stream_fight_event_model.dart';

class FightEventCardList extends StatelessWidget {
  final bool stream;
  final IFightEventModel ife;
  final List<bool>? checkBoxValues;
  final void Function(bool value, int index)? checkBoxOnChanged;

  const FightEventCardList({
    super.key,
    required this.ife,
    required this.stream,
    this.checkBoxValues,
    this.checkBoxOnChanged,
  });

  @override
  Widget build(BuildContext context) {
    IFightEventModel fe = ife;
    print(fe.mainCardCnt);
    print(fe.prelimCardCnt);
    print(fe.earlyCardCnt);
    return Column(
      children:
          (fe.mainCardDateTimeInfo != null && fe.prelimCardDateTimeInfo != null)
              ? List.generate(fe.fighterFightEvents.length, (index) {
                final ffe = fe.fighterFightEvents[index];
                return Column(
                  children: [
                    if (index == 0)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '메인 카드 (${DataUtils.formatDurationToHHMM(fe.mainCardDateTimeInfo!.time)})',
                          style: defaultTextStyle.copyWith(fontSize: 20.0),
                        ),
                      ),
                    if (fe.mainCardCnt == index)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '언더 카드 (${DataUtils.formatDurationToHHMM(fe.prelimCardDateTimeInfo!.time)})',
                          style: defaultTextStyle.copyWith(fontSize: 20.0),
                        ),
                      ),
                    if (fe.earlyCardCnt != 0 &&
                        fe.mainCardCnt! + fe.prelimCardCnt! == index)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          '파이트 패스 언더 카드 (${DataUtils.formatDurationToHHMM(fe.earlyCardDateTimeInfo!.time)})',
                          style: defaultTextStyle.copyWith(fontSize: 20.0),
                        ),
                      ),
                    _renderByIsStream(stream, index, ffe),
                  ],
                );
              })
              : fe.fighterFightEvents
                  .mapIndexed(
                    (index, ffe) => _renderByIsStream(stream, index, ffe),
                  )
                  .toList(),
    );
  }

  Widget _renderByIsStream(bool stream, int index, IFighterFightEvent ffe) {
    return stream
        ? StreamFightEventCard(
          ffe: ffe as StreamFighterFightEventModel,
          upcoming: ffe.status == StreamFighterFightEventStatus.upcoming,
          checkboxValue: checkBoxValues![index],
          checkboxOnChanged: (value) {
            checkBoxOnChanged!.call(value!, index);
          },
        )
        : FightEventCard(
          ffe: ffe as FighterFightEventModel,
          fighterDetail: false,
        );
  }
}
