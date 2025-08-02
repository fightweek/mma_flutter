import 'package:json_annotation/json_annotation.dart';

part 'bet_request_model.g.dart';

@JsonSerializable()
class BetRequestModel {
  final List<SingleBetRequestModel> singleBets;

  BetRequestModel({required this.singleBets});

  Map<String,dynamic> toJson() => _$BetRequestModelToJson(this);
}

@JsonSerializable()
class SingleBetRequestModel{
  final int fighterFightEventId;
  final int winnerId;
  final int loserId;
  final int seedPoint;
  final WinMethodForBet? winMethod;
  final int? winRound;

  SingleBetRequestModel({
    required this.fighterFightEventId,
    required this.winnerId,
    required this.loserId,
    required this.winMethod,
    required this.seedPoint,
    required this.winRound,
  });

  Map<String,dynamic> toJson() => _$SingleBetRequestModelToJson(this);
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
