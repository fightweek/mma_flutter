import 'package:mma_flutter/stream/bet/model/bet_request_model.dart';

/** request를 위한 dio model이 아닌, StreamFightEventModel의 기본 데이터가
 *  BetRequestModel 까지 전달될 수 있도록 하는 징검다리 역할의 model
 */
class SingleBetModel{
  // 타이틀전 여부
  final bool title;
  final int fighterFightEventId;
  final String fightWeight;
  // streamFightEventModel의 winnerName (내가 예측한 winner 아님)
  final String winnerName;
  final String loserName;

  SingleBetModel({
    required this.title,
    required this.fightWeight,
    required this.fighterFightEventId,
    required this.winnerName,
    required this.loserName,
  });

}