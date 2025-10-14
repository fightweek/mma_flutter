import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mma_flutter/common/component/custom_alert_dialog.dart';
import 'package:mma_flutter/common/component/point_with_icon.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/common/const/style.dart';
import 'package:mma_flutter/common/model/base_state_model.dart';
import 'package:mma_flutter/stream/bet/component/bet_history_card.dart';
import 'package:mma_flutter/stream/bet/component/bet_point_box.dart';
import 'package:mma_flutter/stream/bet/model/bet_request_model.dart';
import 'package:mma_flutter/stream/bet/model/bet_response_model.dart';
import 'package:mma_flutter/stream/model/stream_fight_event_model.dart';
import 'package:mma_flutter/stream/bet/provider/bet_history_provider.dart';
import 'package:mma_flutter/stream/provider/stream_fight_event_provider.dart';
import 'package:mma_flutter/user/model/user_model.dart';
import 'package:mma_flutter/user/provider/user_provider.dart';

class BetHistoryScreen extends ConsumerWidget {
  final TabController tabController;
  final int userPoint;

  const BetHistoryScreen({
    required this.tabController,
    required this.userPoint,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eventId = ref.watch(selectedBetHistoryEventIdProvider);
    final user = ref.watch(userProvider) as UserModel;

    if (eventId == null) {
      return Container(
        color: BLACK_COLOR,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final state = ref.watch(betHistoryProvider(eventId))[eventId];

    if (state is StateLoading) {
      return Container(
        color: BLACK_COLOR,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (state is StateError) {
      return Container(
        color: BLACK_COLOR,
        child: Center(
          child: ElevatedButton(
            onPressed: () {
              ref.read(betHistoryProvider(eventId).notifier).getBetHistory();
            },
            child: Text('다시시도', style: defaultTextStyle),
          ),
        ),
      );
    }

    final betHistory = state as StateData<BetResponseModel>;

    final sortedSingleBets =
        betHistory.data!.singleBets
          ..sort((a, b) => b.createdDateTime.compareTo(a.createdDateTime));

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          ref
              .read(betHistoryProvider(eventId).notifier)
              .getBetHistory(forceRefetch: true);
        },
        child: Container(
          color: DARK_GREY_COLOR,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10.h, bottom: 10.h, right: 20.w),
                child: PointWithIcon(point: user.point),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap:
                        eventId > 0
                            ? () {
                              moveBetHistory(
                                ref: ref,
                                eventId: eventId,
                                isLeft: true,
                              );
                            }
                            : null,
                    child: Icon(Icons.keyboard_arrow_left, color: GREY_COLOR),
                  ),
                  SizedBox(
                    width: 300.w,
                    child: Column(
                      children: [
                        Text(
                          '배팅 이력',
                          style: defaultTextStyle.copyWith(fontSize: 17.sp),
                        ),
                        Text(
                          _renderShortEventName(state.data!.eventName),
                          style: defaultTextStyle.copyWith(fontSize: 17.sp),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap:
                        eventId <
                                (ref.read(streamFightEventProvider)
                                        as StateData<StreamFightEventModel>)
                                    .data!
                                    .id
                            ? () {
                              moveBetHistory(
                                ref: ref,
                                eventId: eventId,
                                isLeft: false,
                              );
                            }
                            : null,
                    child: Icon(Icons.keyboard_arrow_right, color: GREY_COLOR),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              betHistory.data!.singleBets.isEmpty
                  ? Expanded(
                    child: ListView(
                      children: [
                        Center(
                          child: Text('배팅 기록이 없습니다.', style: defaultTextStyle),
                        ),
                      ],
                    ),
                  )
                  : Expanded(
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        return _renderSingleBet(
                          singleBet: sortedSingleBets[index],
                          eventId: eventId,
                          ref: ref,
                          context: context,
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 16.h);
                      },
                      itemCount: betHistory.data!.singleBets.length,
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _renderSingleBet({
    required SingleBetResponseModel singleBet,
    required int eventId,
    required WidgetRef ref,
    required BuildContext context,
  }) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            _renderDateTime(singleBet.createdDateTime),
            style: TextStyle(color: GREY_COLOR, fontSize: 12.sp),
          ),
        ),
        Container(
          width: 385.w,
          decoration: BoxDecoration(
            color: BLACK_COLOR,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Column(
            children: [
              ...List.generate(singleBet.betCards.length, (index) {
                return BetHistoryCard(betCard: singleBet.betCards[index]);
              }),
              BetPointBox(point: singleBet.seedPoint, isSeedPoint: true),
              BetPointBox(
                point: _calculateTotalProfit(
                  singleBet.seedPoint,
                  singleBet.betCards,
                ),
                isSeedPoint: false,
                borderColor: WHITE_COLOR,
              ),
              SizedBox(height: 21.h),
              SizedBox(
                width: 127.w,
                height: 31.h,
                child: ElevatedButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                          backgroundColor: DARK_GREY_COLOR,
                          title: Text(
                            '배팅을 취소하시겠습니까?',
                            style: defaultTextStyle.copyWith(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          content: Text(
                            '\n배팅을 취소할 경우, 포인트는 환불됩니다.',
                            style: defaultTextStyle.copyWith(fontSize: 12.sp),
                          ),
                          actions: [
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      backgroundColor: BLACK_COLOR,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadiusGeometry.circular(
                                          8.r,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      '닫기',
                                      style: defaultTextStyle,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      ref
                                          .read(userProvider.notifier)
                                          .updatePoint(
                                        userPoint + singleBet.seedPoint,
                                      );
                                      await ref
                                          .read(
                                        betHistoryProvider(
                                          eventId,
                                        ).notifier,
                                      )
                                          .deleteBet(
                                        eventId: eventId,
                                        seedPoint: singleBet.seedPoint,
                                        betId: singleBet.betId,
                                        userPoint: userPoint,
                                      );
                                      Navigator.of(context).pop();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      backgroundColor: BLUE_COLOR,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadiusGeometry.circular(
                                          8.r,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      '배팅 취소하기',
                                      style: defaultTextStyle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: RED_COLOR,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(8.r))
                  ),
                  child: Text('배팅 취소하기',style: defaultTextStyle.copyWith(fontSize: 14.sp),)
                ),
              ),
              SizedBox(height: 12.h,),
            ],
          ),
        ),
      ],
    );
  }

  String _renderDateTime(DateTime dateTime) {
    final year = dateTime.year;
    final month = dateTime.month;
    final day = dateTime.day;
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '     $year년 $month월 $day일 $hour:$minute';
  }

  void moveBetHistory({
    required WidgetRef ref,
    required int eventId,
    required bool isLeft,
  }) {
    ref
        .read(betHistoryProvider(eventId + (isLeft ? -1 : 1)).notifier)
        .getBetHistory();
    ref
        .read(selectedBetHistoryEventIdProvider.notifier)
        .update((s) => eventId + (isLeft ? -1 : 1));
    tabController.animateTo(3);
  }

  String _renderShortEventName(String eventName) {
    String keyword = 'UFC Fight Night';
    return eventName.contains(keyword)
        ? eventName.replaceAll(keyword, 'UFN')
        : eventName;
  }

  int _calculateTotalProfit(
    int seedMoney,
    List<SingleBetCardResponseModel> betCards,
  ) {
    double total = seedMoney.toDouble();
    for (SingleBetCardResponseModel betCard in betCards) {
      total *= 2;
      final winMethod = betCard.betPrediction.winMethod;
      if (winMethod != null) {
        if (winMethod == WinMethodForBet.dec) {
          total *= 1.5;
        } else {
          if (betCard.betPrediction.winRound != null) {
            total *= 4;
          } else {
            total *= 2;
          }
        }
      } else {
        if (betCard.betPrediction.draw) {
          total *= 15;
        }
      }
    }
    return total.toInt();
  }
}
