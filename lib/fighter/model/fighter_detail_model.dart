import 'package:json_annotation/json_annotation.dart';
import 'package:mma_flutter/event/model/schedule_model.dart';
import 'package:mma_flutter/fighter/model/fighter_model.dart';

part 'fighter_detail_model.g.dart';

@JsonSerializable()
class FighterDetailModel extends FighterModel {
  final String height;
  final DateTime birthday;
  final int? reach;
  final String? nation;
  final List<FighterFightEventModel>? fighterFightEvents;

  FighterDetailModel({
    required super.id,
    required super.name,
    required super.ranking,
    required super.record,
    required super.weight,
    required super.imgPresignedUrl,
    required this.height,
    required this.birthday,
    required this.reach,
    required this.nation,
    required this.fighterFightEvents,
  });

  factory FighterDetailModel.fromJson(Map<String, dynamic> json) =>
      _$FighterDetailModelFromJson(json);
}
