import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mma_flutter/common/const/style.dart';
import 'package:mma_flutter/fight_event/component/fight_event_card.dart';
import 'package:mma_flutter/stream/model/stream_fight_event_model.dart';
import 'package:mma_flutter/stream/provider/stream_fight_event_provider.dart';
import 'package:mma_flutter/common/utils/data_utils.dart';

import '../../common/model/base_state_model.dart';

/// CARDS TAB_BAR_VIEW
class StreamFightEventDetailScreen extends ConsumerStatefulWidget {
  const StreamFightEventDetailScreen({super.key});

  static String get routeName => 'event_detail';

  @override
  ConsumerState<StreamFightEventDetailScreen> createState() =>
      _EventDetailScreenState();
}

class _EventDetailScreenState
    extends ConsumerState<StreamFightEventDetailScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    log('initialize stream_event_detail_screen!');
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(streamFightEventProvider);

    if (state is StateLoading) {
      return Center(child: CircularProgressIndicator());
    }

    final event = state as StateData<StreamFightEventModel>;

    final currentIndex = event.data!.fighterFightEvents.indexWhere(
          (e) => e.status == StreamFighterFightEventStatus.now,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients && currentIndex != -1) {
        print('--animate--');
        _scrollController.animateTo(
          currentIndex * 100.0, // 카드 높이 추정 (조정 필요)
          duration: Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      }
    });

    return SizedBox.expand(
      child: SingleChildScrollView(
        controller: _scrollController,
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            ...List.generate(event.data!.fighterFightEvents.length, (index) {
              final e = event.data!.fighterFightEvents[index];
              return Column(
                children: [
                  if (index == 0)
                    Text(
                      '메인 카드 (${DataUtils.formatDurationToHHMM(event.data!.mainCardDateTimeInfo!.time)})',
                      style: defaultTextStyle.copyWith(fontSize: 20.0),
                    ),
                  if (event.data!.mainCardCnt! == index)
                    Text(
                      '언더 카드 (${DataUtils.formatDurationToHHMM(event.data!.prelimCardDateTimeInfo!.time)})',
                      style: defaultTextStyle.copyWith(fontSize: 20.0),
                    ),
                  if (event.data!.earlyCardCnt != null &&
                      (event.data!.prelimCardCnt! +
                              event.data!.earlyCardCnt!) ==
                          index)
                    Text(
                      '파이트 패스 언더 카드 (${DataUtils.formatDurationToHHMM(event.data!.earlyCardDateTimeInfo!.time)})',
                      style: defaultTextStyle.copyWith(fontSize: 20.0),
                    ),
                  Row(
                    children: [
                      FightEventCard(
                        ffe: e,
                        isUpcoming:
                            e.status != StreamFighterFightEventStatus.previous,
                        isDetail: false,
                        isStream: true,
                      ),
                    ],
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  String formatDateKey(DateTime date) => DateFormat('yyyy-MM-dd').format(date);
}
