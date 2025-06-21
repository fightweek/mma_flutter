import 'package:json_annotation/json_annotation.dart';
import 'package:mma_flutter/event/model/schedule_model.dart';

part 'fighter_model.g.dart';

@JsonSerializable()
class FighterModel {
  final int id;
  final String name;
  final int? ranking;
  final FightRecordModel record;
  final String weight;
  final String imgPresignedUrl;

  FighterModel({
    required this.id,
    required this.name,
    required this.ranking,
    required this.record,
    required this.weight,
    required this.imgPresignedUrl,
  });

  factory FighterModel.fromJson(Map<String, dynamic> json){
    return _$FighterModelFromJson(json);
  }

}
