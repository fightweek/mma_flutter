import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/fight_event/component/fight_event_card_header.dart';
import 'package:mma_flutter/fight_event/component/fight_event_card_row.dart';
import 'package:mma_flutter/fight_event/model/card_date_time_info_model.dart';

import '../model/fight_event_model.dart';

class FightEventCard extends ConsumerWidget {
  final FighterFightEventModel ffe;
  final bool fighterDetail;
  final CardDateTimeInfoModel? eventStartTimeInfo;

  const FightEventCard({
    super.key,
    required this.ffe,
    required this.fighterDetail,
    this.eventStartTimeInfo,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.only(top: 4.h,right: 9.w,left: 9.w),
      child: Container(
        decoration: BoxDecoration(
          color: DARK_GREY_COLOR,
          borderRadius: BorderRadius.circular(8.0),
          // border: BoxBorder.all(color: Colors.white, width: 2),
        ),
        width: MediaQuery.of(context).size.width / 1.05,
        child: Column(
          children: [
            /// (is(Fighter)Detail -> show specific event info of that card)
            if (fighterDetail)
              FightEventCardHeader(
                eventId: ffe.eventId,
                eventName: ffe.eventName,
                eventStartDateTimeInfo: eventStartTimeInfo,
              ),
            FightEventCardRow(ffe: ffe, context: context, ref: ref),
          ],
        ),
      ),
    );
  }

}
