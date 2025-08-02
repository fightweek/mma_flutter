import 'package:mma_flutter/stream/bet_and_vote/model/bet_request_model.dart';

class SingleBetModel{
  // 타이틀전 여부
  final bool title;
  final int fighterFightEventId;
  final int winnerId;
  final int loserId;
  final String winnerName;
  final String loserName;
  final WinMethodForBet? winMethod;
  final int seedPoint;
  final int? winRound;

  SingleBetModel({
    required this.title,
    required this.fighterFightEventId,
    required this.winnerId,
    required this.loserId,
    required this.winnerName,
    required this.loserName,
    required this.winMethod,
    required this.seedPoint,
    required this.winRound,
  });

}