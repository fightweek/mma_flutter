import 'package:json_annotation/json_annotation.dart';
import 'package:mma_flutter/common/model/model_with_id.dart';
import 'package:mma_flutter/fight_event/model/fight_event_model.dart';

part 'fighter_model.g.dart';

@JsonSerializable()
class FighterModel implements ModelWithId{
  @override
  final int id;
  final String name;
  final String? nickname;
  final int? ranking;
  final FightRecordModel record;
  final String? headshotUrl;

  FighterModel({
    required this.id,
    required this.name,
    required this.ranking,
    required this.nickname,
    required this.record,
    required this.headshotUrl,
  });

  factory FighterModel.fromJson(Map<String, dynamic> json){
    return _$FighterModelFromJson(json);
  }

}
