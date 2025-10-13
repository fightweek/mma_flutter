import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/fight_event/component/fight_event_card_header.dart';
import 'package:mma_flutter/fight_event/component/fighter_fight_event_card_row.dart';
import 'package:mma_flutter/fight_event/model/card_date_time_info_model.dart';

import '../model/fight_event_model.dart';

class FighterFightEventCard extends ConsumerWidget {
  final FighterFightEventModel ffe;
  /// fightEventCard or fighterFightEventCard
  final bool isFightEventCard;
  final CardDateTimeInfoModel? eventStartTimeInfo;

  const FighterFightEventCard({
    super.key,
    required this.ffe,
    required this.isFightEventCard,
    this.eventStartTimeInfo,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: BoxBorder.all(color: GREY_COLOR, width: 1.w),
      ),
      width: 362.w,
      child: Column(
        children: [
          /// (is(Fighter)Detail -> show specific event info of that card)
          if (isFightEventCard)
            FightEventCardHeader(
              eventId: ffe.eventId,
              eventName: ffe.eventName,
              eventStartDateTimeInfo: eventStartTimeInfo,
            ),
          FighterFightEventCardRow(ffe: ffe, context: context, ref: ref),
        ],
      ),
    );
  }

}
