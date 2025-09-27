import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/common/const/style.dart';
import 'package:mma_flutter/stream/bet/component/round_buttons.dart';
import 'package:mma_flutter/stream/bet/component/win_method_buttons.dart';
import 'package:mma_flutter/stream/bet/model/bet_response_model.dart';

class BetHistoryCard extends StatelessWidget {
  final SingleBetCardResponseModel betCard;

  const BetHistoryCard({required this.betCard, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 13.h),
          child: Text(
            '${betCard.redName} vs ${betCard.blueName}',
            style: defaultTextStyle.copyWith(fontSize: 17.sp),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                _renderNameBox(
                  label: '승',
                  name: betCard.betPrediction.myWinnerName!,
                  bgColor:
                      !betCard.betPrediction.draw
                          ? betCard.betPrediction.myWinnerName ==
                                  betCard.redName
                              ? RED_COLOR
                              : BLUE_COLOR
                          : DARK_GREY_COLOR,
                  textColor:
                      betCard.betPrediction.draw ? WHITE_COLOR : BLACK_COLOR,
                ),
                SizedBox(height: 6.h),
                _renderNameBox(
                  label: '패',
                  name: betCard.betPrediction.myLoserName!,
                  bgColor: DARK_GREY_COLOR,
                  textColor: WHITE_COLOR,
                ),
              ],
            ),
            Container(
              width: 83.w,
              height: 60.h,
              decoration: BoxDecoration(
                color:
                    betCard.betPrediction.draw
                        ? Color(0xff8a38f5)
                        : DARK_GREY_COLOR,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Center(
                child: Text(
                  '무승부',
                  style: defaultTextStyle.copyWith(fontSize: 15.sp),
                ),
              ),
            ),
          ],
        ),

        /// winMethod != null -> selectedWinMethodIndex는 null이 될 수 없음
        if (!betCard.betPrediction.draw)
          Padding(
            padding: EdgeInsets.only(top: 11.h),
            child: WinMethodButtons(
              isHistory: true,
              mainColor:
                  betCard.betPrediction.myWinnerName == betCard.redName
                      ? RED_COLOR
                      : BLUE_COLOR,
              selectedWinMethodIndex: betCard.betPrediction.winMethod?.index,
            ),
          ),
        if (betCard.betPrediction.winRound != null)
          Padding(
            padding: EdgeInsets.only(top: 11.h),
            child: RoundButtons(
              isTitle: false,
              selectedWinRoundIndex: betCard.betPrediction.winRound! - 1,
              mainColor:
                  betCard.betPrediction.myWinnerName == betCard.redName
                      ? RED_COLOR
                      : BLUE_COLOR,
            ),
          ),
      ],
    );
  }

  Widget _renderNameBox({
    required String label,
    required String name,
    required Color bgColor,
    required Color textColor,
  }) {
    return Row(
      children: [
        Text(label, style: defaultTextStyle.copyWith(fontSize: 12.sp)),
        Padding(
          padding: EdgeInsets.only(left: 24.w),
          child: Container(
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(8.r),
            ),
            width: 208.w,
            height: 27.36.h,
            child: Center(
              child: Text(
                name,
                style: TextStyle(
                  color: textColor,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
