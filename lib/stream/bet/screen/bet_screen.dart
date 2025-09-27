import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mma_flutter/common/component/custom_alert_dialog.dart';
import 'package:mma_flutter/common/component/point_with_icon.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/common/const/data.dart';
import 'package:mma_flutter/common/const/style.dart';
import 'package:mma_flutter/common/model/base_state_model.dart';
import 'package:mma_flutter/stream/bet/component/bet_card.dart';
import 'package:mma_flutter/stream/bet/model/bet_request_model.dart';
import 'package:mma_flutter/stream/bet/provider/bet_card_provider.dart';
import 'package:mma_flutter/stream/bet/provider/bet_history_provider.dart';
import 'package:mma_flutter/stream/model/stream_fight_event_model.dart';
import 'package:mma_flutter/stream/provider/stream_component_providers.dart';
import 'package:mma_flutter/stream/provider/stream_fight_event_provider.dart';
import 'package:mma_flutter/user/model/user_model.dart';
import 'package:mma_flutter/user/provider/user_provider.dart';

class BetScreen extends ConsumerStatefulWidget {
  final TabController tabController;

  const BetScreen({required this.tabController, super.key});

  @override
  ConsumerState<BetScreen> createState() => _BetScreenState();
}

class _BetScreenState extends ConsumerState<BetScreen> {
  late GlobalKey<FormState> formKey;
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    print('bet screen init state');
    formKey = GlobalKey<FormState>();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final betList = ref.watch(betTargetProvider);

    print('rebuild');
    final user = ref.watch(userProvider) as UserModel;

    if (betList.isEmpty) {
      return Container(
        color: DARK_GREY_COLOR,
        child: Center(
          child: Text(
            '이벤트 화면에서 배팅하실 카드를 선택하세요.',
            style: defaultTextStyle.copyWith(fontSize: 16.0),
          ),
        ),
      );
    }

    return SafeArea(
      child: Container(
        color: DARK_GREY_COLOR,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10.h, bottom: 10.h, right: 20.w),
              child: PointWithIcon(point: user.point),
            ),
            Center(
              child: Text(
                '다음 경기의 승자는?',
                style: defaultTextStyle.copyWith(fontSize: 17.sp),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 2.h, bottom: 2.h, right: 20.w),
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return CustomAlertDialog(
                        titleMsg: '포인트 배당',
                        contentMsg: betDescription,
                      );
                    },
                  );
                },
                child: Icon(Icons.question_mark_sharp, color: GREY_COLOR),
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  print(index);
                  return BetCard(bet: betList[index], user: user, index: index);
                },
                separatorBuilder: (context, index) => SizedBox(height: 8.h),
                itemCount: betList.length,
              ),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.h),
                child: Form(
                  key: formKey,
                  child: SizedBox(
                    width: 362.w,
                    child: TextFormField(
                      controller: controller,
                      onChanged: (val) {
                        if (int.tryParse(val) != null) {
                          formKey.currentState!.validate();
                        }
                      },
                      style: TextStyle(color: Colors.white),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(
                          left: 16.w,
                          bottom: 10.h,
                          top: 10.h,
                        ),
                        prefixIcon: Image.asset(
                          'asset/img/icon/point.png',
                          width: 12.w,
                          height: 12.h,
                        ),
                        filled: true,
                        fillColor: BLACK_COLOR,
                        border: linearGradientInputBorder,
                        enabledBorder: linearGradientInputBorder,
                        focusedBorder: linearGradientInputBorder,
                      ),
                      validator: _validator,
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(bottom: 18.h),
                child: SizedBox(
                  width: 127.w,
                  height: 31.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      backgroundColor: BLUE_COLOR,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    onPressed: () {
                      bool allValid = formKey.currentState?.validate() ?? false;
                      print(allValid);
                      if (allValid) {
                        int seedPoint = int.parse(controller.text);
                        print(seedPoint);
                        allValid = seedPoint <= user.point;
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return CustomAlertDialog(
                              titleMsg: '실패',
                              contentMsg:
                                  '배팅 실패. 선택하신 모든 배팅 항목들에 대해 값을 입력해주세요.',
                            );
                          },
                        );
                        return;
                      }
                      if (allValid) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return CustomAlertDialog(
                              contentMsg:
                                  '\n${_betCardsTextInfoForDialog(cards: ref.read(betCardProvider).values.toList(), seedPoint: int.parse(controller.text))}\n배팅하시겠습니까?',
                              actions: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    fixedSize: Size(40.w, 24.h),
                                    backgroundColor: DARK_GREY_COLOR,
                                  ),
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: Text(
                                    '취소',
                                    style: defaultTextStyle.copyWith(
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    final singleBets =
                                        ref
                                            .read(betCardProvider)
                                            .entries
                                            .map(
                                              (e) => SingleBetCardRequestModel(
                                                fighterFightEventId:
                                                    e.value.ffeId,
                                                betPrediction: BetPredictionModel(
                                                  myWinnerName:
                                                      e.value.winnerName,
                                                  myLoserName:
                                                      e.value.loserName,
                                                  draw: e.value.drawSelected,
                                                  winMethod:
                                                      e.value.winMethodIndex !=
                                                              null
                                                          ? WinMethodForBet
                                                              .values[e
                                                              .value
                                                              .winMethodIndex!]
                                                          : null,
                                                  winRound:
                                                      e.value.winRoundIndex !=
                                                              null
                                                          ? e
                                                                  .value
                                                                  .winRoundIndex! +
                                                              1
                                                          : null,
                                                ),
                                              ),
                                            )
                                            .toList();
                                    ref.read(
                                      betCreateFutureProvider(
                                        BetRequestModel(
                                          seedPoint: int.parse(controller.text),
                                          eventId:
                                              (ref.read(
                                                        streamFightEventProvider,
                                                      )
                                                      as StateData<
                                                        StreamFightEventModel
                                                      >)
                                                  .data!
                                                  .id,
                                          singleBetCards: singleBets,
                                        ),
                                      ),
                                    );
                                    Navigator.of(context).pop();
                                    ref.invalidate(betTargetProvider);
                                    ref.invalidate(betCardProvider);
                                    widget.tabController.animateTo(3);
                                    print('성공');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    fixedSize: Size(40.w, 24.h),
                                    backgroundColor: DARK_GREY_COLOR,
                                  ),
                                  child: Text(
                                    '확인',
                                    style: defaultTextStyle.copyWith(
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        print('실패');
                        showDialog(
                          context: context,
                          builder: (context) {
                            return CustomAlertDialog(
                              titleMsg: '실패',
                              contentMsg: '배팅 실패. 전체 입력 포인트가 보유하신 포인트보다 높습니다.',
                            );
                          },
                        );
                      }
                    },
                    child: Text(
                      '전체 배팅하기',
                      style: defaultTextStyle.copyWith(fontSize: 14.sp),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _betCardsTextInfoForDialog({
    required List<BetCardModel> cards,
    required int seedPoint,
  }) {
    if (cards.length != ref.read(betTargetProvider).length) {
      return null;
    }
    String str = '';
    for (int i = 0; i < cards.length; i++) {
      if (cards[i].drawSelected) {
        final redName = ref.read(betTargetProvider)[i].winnerName;
        final blueName = ref.read(betTargetProvider)[i].winnerName;
        str += '카드 ${i + 1} | $redName VS $blueName\n\n예측: 무승부\n';
      } else {
        final myWinnerName = cards[i].winnerName;
        final myLoserName = cards[i].loserName;
        str +=
            '카드 ${i + 1} | $myWinnerName VS $myLoserName\n\n예측 승자: $myWinnerName\n';
        if (cards[i].winMethodIndex != null) {
          str +=
              '승리 방식: ${WinMethodForBet.values[cards[i].winMethodIndex!].label}\n';
        }
        if (cards[i].winRoundIndex != null) {
          str += '승리 라운드: ${cards[i].winRoundIndex! + 1}\n';
        }
      }
      str += '\n';
    }
    str += '배팅 포인트: $seedPoint\n예측 성공 시 획득 가능한 포인트: ${_calculateTotalProfit(seedPoint,cards)}\n';
    return str;
  }

  int _calculateTotalProfit(
      int seedMoney,
      List<BetCardModel> betCards,
      ) {
    double total = seedMoney.toDouble();
    for (BetCardModel betCard in betCards) {
      total *= 2;
      final winMethod = betCard.winMethodIndex != null ? WinMethodForBet.values[betCard.winMethodIndex!] : null;
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

  String? _validator(String? val) {
    final userPoint = (ref.read(userProvider) as UserModel).point;
    if (val == null || val.trim().isEmpty) {
      print('val is null');
      return '배팅하실 포인트를 입력해주세요.';
    }
    if (int.tryParse(val) != null) {
      int parsedVal = int.parse(val);
      print('parsedVal = $parsedVal');
      if (parsedVal <= 0) {
        print('val equal of lower than 0');
        return '0보다 큰 포인트를 배팅해주세요.';
      }
      if (parsedVal % 100 != 0) {
        print('val should be multiple of 10');
        return '배팅 포인트는 100의 배수여야 합니다.';
      }
      if (parsedVal > userPoint) {
        print('point shortage');
        return '포인트가 부족합니다.';
      }
    }
    return null;
  }
}
