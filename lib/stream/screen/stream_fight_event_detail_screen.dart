import 'dart:developer';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/common/const/style.dart';
import 'package:mma_flutter/common/utils/data_utils.dart';
import 'package:mma_flutter/fight_event/component/fight_event_card_list.dart';
import 'package:mma_flutter/fight_event/component/stream_fight_event_card.dart';
import 'package:mma_flutter/stream/bet_and_vote/model/bet_request_model.dart';
import 'package:mma_flutter/stream/bet_and_vote/model/single_bet_model.dart';
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

    print('stream fight event detail screen rebuild!');
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

    // final currentIndex = event.data!.fighterFightEvents.indexWhere(
    //   (e) => e.status == StreamFighterFightEventStatus.now,
    // );
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (_scrollController.hasClients && currentIndex != -1) {
    //     print('--animate--');
    //     _scrollController.animateTo(
    //       currentIndex * 100.0, // 카드 높이 추정 (조정 필요)
    //       duration: Duration(milliseconds: 800),
    //       curve: Curves.easeInOut,
    //     );
    //   }
    // });

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
                height: 22.h,
                left: 155.w,
                right: 155.w,
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(betTargetProvider.notifier).update((state) {
                      return event.data!.fighterFightEvents
                          .mapIndexed((index, element) {
                            if (checkBoxValues[index] == true) {
                              return SingleBetModel(
                                title: element.title,
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
                    backgroundColor: BLUE_COLOR,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    '배팅하기',
                    style: defaultTextStyle.copyWith(fontSize: 10.sp),
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
