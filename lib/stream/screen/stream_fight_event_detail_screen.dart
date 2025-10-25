import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/common/const/style.dart';
import 'package:mma_flutter/fight_event/component/fight_event_card_list.dart';
import 'package:mma_flutter/stream/bet/model/single_bet_model.dart';
import 'package:mma_flutter/stream/bet/provider/bet_card_provider.dart';
import 'package:mma_flutter/stream/model/stream_fight_event_model.dart';
import 'package:mma_flutter/stream/provider/stream_component_providers.dart';
import 'package:mma_flutter/stream/provider/stream_fight_event_provider.dart';

import '../../common/model/base_state_model.dart';

/// CARDS TAB_BAR_VIEW
class StreamFightEventDetailScreen extends ConsumerStatefulWidget {
  final TabController tabController;

  const StreamFightEventDetailScreen({required this.tabController, super.key});

  static String get routeName => 'event_detail';

  @override
  ConsumerState<StreamFightEventDetailScreen> createState() =>
      _EventDetailScreenState();
}

class _EventDetailScreenState
    extends ConsumerState<StreamFightEventDetailScreen> {
  List<bool> checkBoxValues = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    log('initialize stream_event_detail_screen!');
    final state = ref.read(streamFightEventProvider);
    if (state is StateData<StreamFightEventModel>) {
      checkBoxValues = List.generate(
        state.data!.fighterFightEvents.length,
        (index) => false,
      );
    }
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool betAvailable = checkBoxValues.any((value) => value);

    final state = ref.watch(streamFightEventProvider);

    if (state is StateLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (state is StateError) {
      return ElevatedButton(
        onPressed: () {
          ref
              .read(streamFightEventProvider.notifier)
              .getCurrentFightEventInfo();
        },
        child: Text('다시시도'),
      );
    }

    final event = state as StateData<StreamFightEventModel>;

    return SafeArea(
      child: Container(
        color: DARK_GREY_COLOR,
        child: Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  FightEventCardList(
                    ife: event.data!,
                    stream: true,
                    isFirstCardExcluded: false,
                    checkBoxValues: checkBoxValues,
                    checkBoxOnChanged: (value, index) {
                      setState(() {
                        checkBoxValues[index] = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            if (betAvailable)
              Positioned(
                bottom: 18.h,
                height: 31.h,
                left: 137.5.w,
                right: 137.5.w,
                child: SizedBox(
                  height: 31.h,
                  child: ElevatedButton(
                    onPressed: () {
                      ref.invalidate(betCardProvider);
                      ref.read(betTargetProvider.notifier).update((state) {
                        return event.data!.fighterFightEvents
                            .mapIndexed((index, element) {
                              if (checkBoxValues[index] == true) {
                                return SingleBetModel(
                                  title: element.title,
                                  fightWeight: element.fightWeight,
                                  fighterFightEventId: element.id,
                                  winnerName: element.winner.name,
                                  loserName: element.loser.name,
                                );
                              }
                              return null;
                            })
                            .whereType<SingleBetModel>()
                            .toList();
                      });
                      widget.tabController.animateTo(2);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor: BLUE_COLOR,
                      foregroundColor: WHITE_COLOR,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(
                      '배팅하러 가기',
                      style: defaultTextStyle.copyWith(fontSize: 14.sp),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String formatDateKey(DateTime date) => DateFormat('yyyy-MM-dd').format(date);
}
