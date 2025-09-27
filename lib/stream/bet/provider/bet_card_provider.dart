import 'package:flutter_riverpod/flutter_riverpod.dart';

/// my bet card index : my card prediction (index는 내가 체크박스로 선택한  betTargetList의 index)
final betCardProvider = StateProvider<Map<int, BetCardModel>>((ref) => {});

class BetCardModel {
  final int ffeId;
  final String? winnerName;
  final String? loserName;
  final bool drawSelected;
  final bool? leftNameSelected;
  final int? winMethodIndex;
  final int? winRoundIndex;

  const BetCardModel({
    required this.ffeId,
    this.winnerName,
    this.loserName,
    this.drawSelected = false,
    this.leftNameSelected,
    this.winMethodIndex,
    this.winRoundIndex,
  });

  BetCardModel copyWith({
    String? newWinnerName,
    String? newLoserName,
    bool? newDrawSelected,
    int? newWinMethodIndex,
    bool? newLeftNameSelected,
    int? newWinRoundIndex,
  }) {
    return BetCardModel(
      ffeId: ffeId,
      winnerName: newWinnerName ?? winnerName,
      loserName: newLoserName ?? loserName,
      drawSelected: newDrawSelected ?? drawSelected,
      winMethodIndex: newWinMethodIndex ?? winMethodIndex,
      winRoundIndex: newWinRoundIndex ?? winRoundIndex,
      leftNameSelected: newLeftNameSelected ?? leftNameSelected,
    );
  }
}
