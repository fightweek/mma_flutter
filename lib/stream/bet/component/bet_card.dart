import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/common/const/data.dart';
import 'package:mma_flutter/common/const/style.dart';
import 'package:mma_flutter/stream/bet/component/round_buttons.dart';
import 'package:mma_flutter/stream/bet/component/select_winner_buttons.dart';
import 'package:mma_flutter/stream/bet/component/win_method_buttons.dart';
import 'package:mma_flutter/stream/bet/model/single_bet_model.dart';
import 'package:mma_flutter/stream/bet/provider/bet_card_provider.dart';
import 'package:mma_flutter/stream/provider/stream_component_providers.dart';
import 'package:mma_flutter/user/model/user_model.dart';

class BetCard extends ConsumerWidget {
  final SingleBetModel bet;
  final UserModel user;
  final int index;

  const BetCard({
    required this.bet,
    required this.user,
    required this.index,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final betCardState = ref.watch(betCardProvider)[index];
    final nameSelected =
        betCardState?.winnerName != null &&
                betCardState?.leftNameSelected != null
            ? true
            : false;
    final drawSelected = (betCardState?.drawSelected ?? false) ? true : false;
    final winMethodIndex = betCardState?.winMethodIndex;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: BLACK_COLOR,
          borderRadius: BorderRadius.circular(8.r)
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        '${weightClassMap[bet.fightWeight]} ${bet.title ? '타이틀전' : '매치'}',
                        style: defaultTextStyle.copyWith(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        ref.read(betTargetProvider.notifier).update((state) {
                          final singleBetModelToRemove =
                              List<SingleBetModel>.from(state); // copy
                          singleBetModelToRemove.removeWhere(
                            (e) => e.winnerName == bet.winnerName,
                          );
                          return singleBetModelToRemove;
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: Icon(
                          FontAwesomeIcons.x,
                          color: Colors.white,
                          size: 15.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: SizedBox(
                height: 28.h,
                child: SelectWinnerButtons(
                  bet: bet,
                  index: index,
                  betCardState: betCardState,
                  drawSelected: drawSelected,
                ),
              ),
            ),
            if (nameSelected && !drawSelected)
              _winMethodButtons(
                leftNameSelected: betCardState!.leftNameSelected!,
                ref: ref,
                selectedWinMethodIndex: betCardState.winMethodIndex,
              ),
            if (winMethodIndex != null &&
                !drawSelected &&
                (winMethodIndex == 0 || winMethodIndex == 1))
              _selectWhichRoundToFinish(
                isTitle: bet.title,
                leftNameSelected: betCardState!.leftNameSelected!,
                selectedWinRoundIndex: betCardState.winRoundIndex,
                ref: ref,
              ),
            SizedBox(height: 28.h),
            // Text(_renderSelectedBetOptions()),
          ],
        ),
      ),
    );
  }

  Widget _winMethodButtons({
    required bool leftNameSelected,
    required WidgetRef ref,
    required int? selectedWinMethodIndex,
  }) {
    final mainColor = leftNameSelected ? RED_COLOR : BLUE_COLOR;
    return WinMethodButtons(
      isHistory: false,
      mainColor: mainColor,
      selectedWinMethodIndex: selectedWinMethodIndex,
      onPressed: (winMethodIndex) {
        ref.read(betCardProvider.notifier).update((state) {
          final prev = state[index];
          return {
            ...state,
            index:
                prev!.winMethodIndex != null &&
                        prev.winMethodIndex == winMethodIndex
                    ? BetCardModel(
                      ffeId: prev.ffeId,
                      winnerName: prev.winnerName,
                      loserName: prev.loserName,
                      leftNameSelected: prev.leftNameSelected,
                      winMethodIndex: null,
                      winRoundIndex: null,
                      drawSelected: false,
                    )
                    : prev.copyWith(newWinMethodIndex: winMethodIndex),
          };
        });
      },
    );
  }

  Widget _selectWhichRoundToFinish({
    required bool isTitle,
    required bool leftNameSelected,
    required int? selectedWinRoundIndex,
    required WidgetRef ref,
  }) {
    final mainColor = leftNameSelected ? RED_COLOR : BLUE_COLOR;
    return RoundButtons(
      isTitle: isTitle,
      selectedWinRoundIndex: selectedWinRoundIndex,
      onPressed: (winRoundIndex) {
        ref.read(betCardProvider.notifier).update((state) {
          final prev = state[index];
          return {
            ...state,
            index:
                prev!.winRoundIndex != null && prev.winRoundIndex == winRoundIndex
                    ? BetCardModel(
                      ffeId: prev.ffeId,
                      winnerName: prev.winnerName,
                      loserName: prev.loserName,
                      leftNameSelected: prev.leftNameSelected,
                      winMethodIndex: prev.winMethodIndex,
                      winRoundIndex: null,
                      drawSelected: false,
                    )
                    : prev.copyWith(newWinRoundIndex: winRoundIndex),
          };
        });
      },
      mainColor: mainColor,
    );
  }

  // String _renderSelectedBetOptions() {
  //   final betWinner = _leftNameSelected ? bet.winnerName : bet.loserName;
  //   final winMethod =
  //       _selectedWinMethodIndex != null
  //           ? (WinMethodForBet.values.elementAt(_selectedWinMethodIndex!)).label
  //           : null;
  //   final winRound =
  //       _selectedWinMethodIndex != null &&
  //               _selectedWinRoundIndex != null &&
  //               (_selectedWinMethodIndex == 0 || _selectedWinMethodIndex == 1)
  //           ? '${_selectedWinRoundIndex! + 1}R'
  //           : null;
  //   final subStrInAsk = '$betWinner의 ${winRound ?? ''} ${winMethod ?? ''} ';
  //   final askStr = winMethod == '무승부' ? '무승부?' : subStrInAsk;
  //   return askStr;
  // }
}
