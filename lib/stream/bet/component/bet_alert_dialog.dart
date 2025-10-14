import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/common/const/style.dart';
import 'package:mma_flutter/common/model/base_state_model.dart';
import 'package:mma_flutter/common/utils/data_utils.dart';
import 'package:mma_flutter/stream/bet/component/bet_point_box.dart';
import 'package:mma_flutter/stream/bet/model/bet_request_model.dart';
import 'package:mma_flutter/stream/bet/provider/bet_card_provider.dart';
import 'package:mma_flutter/stream/bet/provider/bet_history_provider.dart';
import 'package:mma_flutter/stream/model/stream_fight_event_model.dart';
import 'package:mma_flutter/stream/provider/stream_component_providers.dart';
import 'package:mma_flutter/stream/provider/stream_fight_event_provider.dart';

class BetAlertDialog extends ConsumerWidget {
  final TabController tabController;
  final TextEditingController textEditingController;

  const BetAlertDialog({
    required this.tabController,
    required this.textEditingController,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      scrollable: true,
      backgroundColor: DARK_GREY_COLOR,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(8.r),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height:
                ref.read(betCardProvider).values.length > 1 ? 248.h : 124.h,
            child: RawScrollbar(
              thumbVisibility: true,
              thumbColor: BLUE_COLOR,
              trackColor: BLACK_COLOR,
              radius: Radius.circular(8.r),
              trackVisibility: true,
              child: Padding(
                padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 12.h),
                child: _renderBetCards(
                  cards: ref.read(betCardProvider).values.toList(),
                  ref: ref,
                  seedPoint: int.parse(textEditingController.text),
                ),
              ),
            ),
          ),
          BetPointBox(
            point: int.parse(textEditingController.text),
            isSeedPoint: true,
            backGroundColor: BLACK_COLOR,
          ),
          BetPointBox(
            point: _calculateTotalProfit(
              int.parse(textEditingController.text),
              ref.read(betCardProvider).values.toList(),
            ),
            isSeedPoint: false,
            borderColor: WHITE_COLOR,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: Center(
              child: Text(
                '배팅하시겠습니까?',
                style: defaultTextStyle.copyWith(fontSize: 14.sp),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: BLACK_COLOR,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(8.r),
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    '취소',
                    style: defaultTextStyle.copyWith(fontSize: 12.sp),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    final singleBets =
                        ref
                            .read(betCardProvider)
                            .entries
                            .map(
                              (e) => SingleBetCardRequestModel(
                                fighterFightEventId: e.value.ffeId,
                                betPrediction: BetPredictionModel(
                                  myWinnerName: e.value.winnerName,
                                  myLoserName: e.value.loserName,
                                  draw: e.value.drawSelected,
                                  winMethod:
                                      e.value.winMethodIndex != null
                                          ? WinMethodForBet.values[e
                                              .value
                                              .winMethodIndex!]
                                          : null,
                                  winRound:
                                      e.value.winRoundIndex != null
                                          ? e.value.winRoundIndex! + 1
                                          : null,
                                ),
                              ),
                            )
                            .toList();
                    ref.read(
                      betCreateFutureProvider(
                        BetRequestModel(
                          seedPoint: int.parse(textEditingController.text),
                          eventId:
                              (ref.read(streamFightEventProvider)
                                      as StateData<StreamFightEventModel>)
                                  .data!
                                  .id,
                          singleBetCards: singleBets,
                        ),
                      ),
                    );
                    Navigator.of(context).pop();
                    ref.invalidate(betTargetProvider);
                    ref.invalidate(betCardProvider);
                    tabController.animateTo(3);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: BLUE_COLOR,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(8.r),
                    ),
                  ),
                  child: Text(
                    '배팅하기',
                    style: defaultTextStyle.copyWith(fontSize: 12.sp),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _renderBetCards({
    required WidgetRef ref,
    required List<BetCardModel> cards,
    required int seedPoint,
  }) {
    return ListView.separated(
      itemBuilder: (context, index) {
        if (cards[index].drawSelected) {
          final redName = ref.read(betTargetProvider)[index].winnerName;
          final blueName = ref.read(betTargetProvider)[index].loserName;
          return Column(
            children: [
              _renderLabelWithValue(
                label: 'Card ${index + 1}',
                value:
                    '${DataUtils.extractLastName(redName)} vs ${DataUtils.extractLastName(blueName)}',
              ),
              _renderLabelWithValue(label: '예측', value: '무승부'),
            ],
          );
        }
        final myWinnerName = cards[index].winnerName;
        final myLoserName = cards[index].loserName;
        return Column(
          children: [
            _renderLabelWithValue(
              label: 'Card ${index + 1}',
              value:
                  '${DataUtils.extractLastName(myWinnerName!)} vs ${DataUtils.extractLastName(myLoserName!)}',
            ),
            _renderLabelWithValue(
              label: '예측 승자',
              value: DataUtils.extractLastName(myWinnerName),
            ),
            if (cards[index].winMethodIndex != null)
              _renderLabelWithValue(
                label: '승리 방식',
                value:
                    WinMethodForBet.values[cards[index].winMethodIndex!].label,
              ),
            if (cards[index].winRoundIndex != null)
              _renderLabelWithValue(
                label: '라운드',
                value: '${cards[index].winRoundIndex! + 1}R',
              ),
          ],
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return Column(
          children: [
            Container(height: 2.h, width: 226.w, color: GREY_COLOR),
            SizedBox(height: 14.h),
          ],
        );
      },
      itemCount: cards.length,
    );
  }

  Widget _renderLabelWithValue({required String label, required String value}) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 50.w,
              child: Text(
                label,
                style: defaultTextStyle.copyWith(
                  color: GREY_COLOR,
                  fontSize: 12.sp,
                ),
              ),
            ),
            SizedBox(width: 16.w),
            SizedBox(
              width: 160.w,
              child: Text(
                value,
                style: defaultTextStyle.copyWith(
                  fontSize: label.contains('Card') ? 15.sp : 13.sp,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
      ],
    );
  }

  int _calculateTotalProfit(int seedMoney, List<BetCardModel> betCards) {
    double total = seedMoney.toDouble();
    for (BetCardModel betCard in betCards) {
      total *= 2;
      final winMethod =
          betCard.winMethodIndex != null
              ? WinMethodForBet.values[betCard.winMethodIndex!]
              : null;
      if (winMethod != null) {
        if (winMethod == WinMethodForBet.dec) {
          total *= 1.5;
        } else {
          if (betCard.winRoundIndex != null) {
            total *= 4;
          } else {
            total *= 2;
          }
        }
      } else {
        if (betCard.drawSelected) {
          total *= 15;
        }
      }
    }
    return total.toInt();
  }
}
