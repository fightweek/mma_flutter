import 'package:json_annotation/json_annotation.dart';
import 'package:mma_flutter/fight_event/model/fight_event_model.dart';
import 'package:mma_flutter/fighter/model/fighter_model.dart';

part 'fighter_detail_model.g.dart';

@JsonSerializable()
class FighterDetailModel extends FighterModel {
  final int height;
  final double? weight;
  final DateTime? birthday;
  final int? reach;
  final String? nation;
  final bool alert;
  final List<FighterFightEventModel>? fighterFightEvents;

  FighterDetailModel({
    required super.id,
    required super.name,
    required super.ranking,
    required super.record,
    required super.nickname,
    required super.headshotUrl,
    required this.height,
    required this.weight,
    required this.birthday,
    required this.reach,
    required this.alert,
    required this.nation,
    required this.fighterFightEvents,
  });

  factory FighterDetailModel.fromJson(Map<String, dynamic> json) =>
      _$FighterDetailModelFromJson(json);

  FighterDetailModel copyWith({bool? like, }) {
    return FighterDetailModel(
      id: id,
      name: name,
      ranking: ranking,
      record: record,
      weight: weight,
      nickname: nickname,
      headshotUrl: headshotUrl,
      height: height,
      birthday: birthday,
      reach: reach,
      alert: like ?? this.alert,
      nation: nation,
      fighterFightEvents: fighterFightEvents,
    );
  }
}
