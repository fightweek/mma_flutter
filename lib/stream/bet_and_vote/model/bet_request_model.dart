import 'package:json_annotation/json_annotation.dart';

part 'bet_request_model.g.dart';

@JsonSerializable()
class BetRequestModel {
  final List<SingleBetCardRequestModel> singleBetCards;

  BetRequestModel({required this.singleBetCards});

  Map<String,dynamic> toJson() => _$BetRequestModelToJson(this);
}

@JsonSerializable()
class SingleBetCardRequestModel{
  final int fighterFightEventId;
  final int seedPoint;
  final BetPredictionModel betPrediction;

  SingleBetCardRequestModel({
    required this.fighterFightEventId,
    required this.seedPoint,
    required this.betPrediction,
  });

  Map<String,dynamic> toJson() => _$SingleBetCardRequestModelToJson(this);
}

@JsonSerializable()
class BetPredictionModel{
  final String winnerName;
  final String loserName;
  final WinMethodForBet? winMethod;
  final int? winRound;

  BetPredictionModel({
    required this.winnerName,
    required this.loserName,
    required this.winMethod,
    required this.winRound,
  });

  Map<String,dynamic> toJson() => _$BetPredictionModelToJson(this);

  factory BetPredictionModel.fromJson(Map<String, dynamic> json)
  => _$BetPredictionModelFromJson(json);

}

enum WinMethodForBet {
  @JsonValue("SUB")
  sub,
  @JsonValue("KO_TKO")
  koTko,
  @JsonValue("DEC")
  dec,
  @JsonValue(("DRAW"))
  draw,
}

extension WinMethodExtension on WinMethodForBet {
  String get label {
    switch (this) {
      case WinMethodForBet.sub:
        return '서브미션';
      case WinMethodForBet.koTko:
        return 'KO/TKO';
      case WinMethodForBet.dec:
        return '판정승';
      case WinMethodForBet.draw:
        return '무승부';
    }
  }
}
