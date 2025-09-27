import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/common/const/style.dart';
import 'package:mma_flutter/common/utils/data_utils.dart';
import 'package:mma_flutter/stream/bet/model/single_bet_model.dart';
import 'package:mma_flutter/stream/bet/provider/bet_card_provider.dart';

class SelectWinnerButtons extends ConsumerWidget {
  final SingleBetModel bet;
  final int index;
  final BetCardModel? betCardState;
  final bool drawSelected;

  const SelectWinnerButtons({
    required this.bet,
    required this.index,
    required this.betCardState,
    required this.drawSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    print(betCardState);
    return Row(
      children: [
        Expanded(
          child: _nameButton(
            mainColor: RED_COLOR,
            myWinnerName: bet.winnerName,
            myLoserName: bet.loserName,
            isLeft: true,
            ref: ref,
            state: betCardState,
            drawSelected: drawSelected,
            ffeId: bet.fighterFightEventId,
          ),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: _nameButton(
            mainColor: BLUE_COLOR,
            myWinnerName: bet.loserName,
            myLoserName: bet.winnerName,
            isLeft: false,
            ref: ref,
            state: betCardState,
            drawSelected: drawSelected,
            ffeId: bet.fighterFightEventId,
          ),
        ),
        SizedBox(width: 4.w),
        _drawButton(
          ref: ref,
          drawSelected: drawSelected,
          mainColor: Color(0xff8a38f5),
        ),
      ],
    );
  }

  ElevatedButton _nameButton({
    required Color mainColor,
    required String myWinnerName,
    required String myLoserName,
    required bool isLeft,
    required WidgetRef ref,
    required BetCardModel? state,
    required bool drawSelected,
    required int ffeId,
  }) {
    /// 둘(빨/파) 중 어떤 이름이 선택되어 있는 경우
    bool isSelected =
        state == null || drawSelected
            ? false
            : (isLeft
                ? state.leftNameSelected ?? false
                : state.leftNameSelected == null
                ? false
                : !state.leftNameSelected!);
    print(isSelected);
    return ElevatedButton(
      onPressed: () {
        ref.read(betCardProvider.notifier).update((stateMap) {
          // 이미 선택된 버튼 다시 눌렀으니 해제
          return {
            ...stateMap,
            index:
                isSelected
                    ? BetCardModel(
                      ffeId: state.ffeId,
                      drawSelected: false,
                      leftNameSelected: null,
                      winRoundIndex: null,
                      winMethodIndex: null,
                      winnerName: null,
                      loserName: null,
                    )
                    : BetCardModel(ffeId: ffeId).copyWith(
                      newWinnerName: myWinnerName,
                      newLoserName: myLoserName,
                      newLeftNameSelected: isLeft,
                      newDrawSelected: false,
                      newWinRoundIndex: null,
                      newWinMethodIndex: null,
                    ),
          };
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? BLACK_COLOR : mainColor,
        side: BorderSide(width: 2.w, color: mainColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(8.r),
        ),
      ),
      child: Text(
        DataUtils.extractLastName(myWinnerName),
        style: defaultTextStyle.copyWith(
          fontSize: 15.sp,
          fontWeight: FontWeight.w700,
          color: isSelected ? mainColor : BLACK_COLOR,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  ElevatedButton _drawButton({
    required WidgetRef ref,
    required bool drawSelected,
    required Color mainColor,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        fixedSize: Size(57.w, 28.h),
        backgroundColor: drawSelected ? BLACK_COLOR : mainColor,
        side: BorderSide(width: 2.w, color: mainColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
      onPressed: () {
        ref.read(betCardProvider.notifier).update((state) {
          final prev = state[index];
          return {
            ...state,
            index:
                (prev?.copyWith(newDrawSelected: !drawSelected) ??
                    BetCardModel(ffeId: bet.fighterFightEventId).copyWith(
                      newLeftNameSelected: null,
                      newDrawSelected: true,
                      newWinRoundIndex: null,
                      newWinMethodIndex: null,
                      newLoserName: null,
                      newWinnerName: null,
                    )),
          };
        });
      },
      child: Text(
        '무승부',
        style: TextStyle(
          fontSize: 15.sp,
          fontWeight: FontWeight.w600,
          color: drawSelected ? mainColor : BLACK_COLOR,
        ),
      ),
    );
  }
}
