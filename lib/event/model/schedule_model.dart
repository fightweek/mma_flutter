import 'package:json_annotation/json_annotation.dart';

part 'schedule_model.g.dart';

@JsonSerializable()
class FightEventModel {
  final int id;
  final String name;

  // @JsonKey(fromJson: DataUtils.stringToDateTime)
  final DateTime date;
  final String location;
  final List<FighterFightEventModel> fighterFightEvents;

  FightEventModel({
    required this.id,
    required this.name,
    required this.date,
    required this.location,
    required this.fighterFightEvents,
  });

  factory FightEventModel.fromJson(Map<String, dynamic> json) =>
      _$FightEventModelFromJson(json);
}

@JsonSerializable()
class FighterFightEventModel {
  final String fightWeight;
  final String winnerName;
  final FightRecordModel winnerRecord;
  final String loserName;
  final FightRecordModel loserRecord;
  final String winnerImgPresignedUrl;
  final String loserImgPresignedUrl;

  FighterFightEventModel({
    required this.fightWeight,
    required this.winnerName,
    required this.winnerRecord,
    required this.loserName,
    required this.loserRecord,
    required this.winnerImgPresignedUrl,
    required this.loserImgPresignedUrl,
  });

  factory FighterFightEventModel.fromJson(Map<String, dynamic> json) =>
      _$FighterFightEventModelFromJson(json);
}

@JsonSerializable()
class FightRecordModel {
  final int win;
  final int loss;
  final int draw;

  FightRecordModel({required this.win, required this.loss, required this.draw});

  factory FightRecordModel.fromJson(Map<String, dynamic> json) =>
      _$FightRecordModelFromJson(json);
}
