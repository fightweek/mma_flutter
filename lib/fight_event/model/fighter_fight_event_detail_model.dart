import 'package:json_annotation/json_annotation.dart';
import 'package:mma_flutter/fight_event/model/fight_event_model.dart';
import 'package:mma_flutter/fighter/model/fighter_model.dart';

part 'fighter_fight_event_detail_model.g.dart';

@JsonSerializable()
class FighterFightEventDetailModel {
  final FighterFightEventFighterModel winner;
  final FighterFightEventFighterModel loser;
  final String fightWeight;

  FighterFightEventDetailModel({
    required this.winner,
    required this.loser,
    required this.fightWeight,
  });

  factory FighterFightEventDetailModel.fromJson(Map<String, dynamic> json)
  => _$FighterFightEventDetailModelFromJson(json);
}

@JsonSerializable()
class FighterFightEventFighterModel extends FighterModel {
  final int? reach;
  final DateTime birthday;
  final int height;
  final String bodyUrl;
  final double? weight;

  FighterFightEventFighterModel({
    required super.id,
    required super.name,
    required super.nickname,
    required super.record,
    required super.ranking,
    required super.headshotUrl,
    required this.weight,
    required this.height,
    required this.birthday,
    required this.reach,
    required this.bodyUrl,
  });

  factory FighterFightEventFighterModel.fromJson(Map<String, dynamic> json) =>
      _$FighterFightEventFighterModelFromJson(json);
}

