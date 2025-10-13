// import 'package:json_annotation/json_annotation.dart';
// import 'package:mma_flutter/common/model/model_with_id.dart';
// import 'package:mma_flutter/fight_event/model/fight_event_model.dart';
//
// part 'fight_event_pagination_model.g.dart';
//
// @JsonSerializable()
// class FightEventPaginationModel implements ModelWithId{
//   @override
//   final int id;
//   final String name;
//   final String winnerName;
//   final String loserName;
//   final String winnerHeadshotUrl;
//   final String loserHeadshotUrl;
//   final FightRecordModel winnerRecord;
//   final FightRecordModel loserRecord;
//
//   FightEventPaginationModel({
//     required this.id,
//     required this.name,
//     required this.winnerName,
//     required this.loserName,
//     required this.winnerHeadshotUrl,
//     required this.loserHeadshotUrl,
//     required this.winnerRecord,
//     required this.loserRecord,
//   });
//
//   factory FightEventPaginationModel.fromJson(Map<String, dynamic> json)
//   => _$FightEventPaginationModelFromJson(json);
// }
