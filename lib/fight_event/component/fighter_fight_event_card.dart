import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/common/model/base_state_model.dart';
import 'package:mma_flutter/fight_event/component/fight_event_card_header.dart';
import 'package:mma_flutter/fight_event/component/fight_event_card_list.dart';
import 'package:mma_flutter/fight_event/component/fighter_fight_event_card_row.dart';
import 'package:mma_flutter/fight_event/model/card_date_time_info_model.dart';
import 'package:mma_flutter/fight_event/provider/fight_event_provider.dart';

import '../model/fight_event_model.dart';

class FighterFightEventCard extends ConsumerStatefulWidget {
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
  ConsumerState<FighterFightEventCard> createState() =>
      _FighterFightEventCardState();
}

class _FighterFightEventCardState extends ConsumerState<FighterFightEventCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final eventState = ref.watch(
      fightEventProvider.select(
        (state) => state[formatDateKey(widget.ffe.eventDate)],
      ),
    );

    return Column(
      children: [
        if (widget.isFightEventCard)
          FightEventCardHeader(
            eventId: widget.ffe.eventId,
            eventName: widget.ffe.eventName,
            eventStartDateTimeInfo: widget.eventStartTimeInfo,
          ),
        if (widget.isFightEventCard)
          Stack(
            clipBehavior: Clip.none,
            children: [
              AnimatedSize(
                duration: Duration(milliseconds: 300),
                child: Column(
                  children: [
                    FighterFightEventCardRow(ffe: widget.ffe, context: context),
                    if (_isExpanded) _renderAllCards(eventState: eventState),
                  ],
                ),
              ),
              Positioned(
                bottom: -8.h,
                left: 0,
                right: 0,
                child: Container(
                  width: 20.w,
                  height: 20.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: GREY_COLOR, width: 1.w),
                    color: DARK_GREY_COLOR,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      ref
                          .read(fightEventProvider.notifier)
                          .getSchedule(date: widget.ffe.eventDate);
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                    },
                    child: Icon(
                      _isExpanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: WHITE_COLOR,
                      size: 18.r,
                    ),
                  ),
                ),
              ),
            ],
          ),
        if (!widget.isFightEventCard)
          FighterFightEventCardRow(ffe: widget.ffe, context: context),
      ],
    );
  }

  String formatDateKey(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

  Widget _renderAllCards({required StateBase<FightEventModel>? eventState}) {
    if (eventState == null || eventState is StateLoading) {
      return Center(child: CircularProgressIndicator());
    }
    final event = eventState as StateData<FightEventModel>;
    return FightEventCardList(ife: event.data!, stream: false);
  }
}
