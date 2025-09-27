import 'package:json_annotation/json_annotation.dart';

part 'bet_request_model.g.dart';

@JsonSerializable()
class BetRequestModel {
  final int eventId;

  final int seedPoint;

  final List<SingleBetCardRequestModel> singleBetCards;

  BetRequestModel({
    required this.eventId,
    required this.seedPoint,
    required this.singleBetCards,
  });

  Map<String, dynamic> toJson() => _$BetRequestModelToJson(this);
}

@JsonSerializable()
class SingleBetCardRequestModel {
  final int fighterFightEventId;
  final BetPredictionModel betPrediction;

  SingleBetCardRequestModel({
    required this.fighterFightEventId,
    required this.betPrediction,
  });

  Map<String, dynamic> toJson() => _$SingleBetCardRequestModelToJson(this);
}

@JsonSerializable()
class BetPredictionModel {
  final String? myWinnerName;
  final String? myLoserName;
  final WinMethodForBet? winMethod;
  final bool draw;
  final int? winRound;

  BetPredictionModel({
    required this.myWinnerName,
    required this.myLoserName,
    this.winMethod,
    this.winRound,
    this.draw=false,
  });

  Map<String, dynamic> toJson() => _$BetPredictionModelToJson(this);

  factory BetPredictionModel.fromJson(Map<String, dynamic> json) =>
      _$BetPredictionModelFromJson(json);
}

enum WinMethodForBet {
  @JsonValue("SUB")
  sub,
  @JsonValue("KO_TKO")
  koTko,
  @JsonValue("DEC")
  dec,
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
    }
  }
}
