import 'package:json_annotation/json_annotation.dart';
import 'package:mma_flutter/fight_event/model/fight_event_model.dart';
import 'package:mma_flutter/fighter/model/fighter_model.dart';

part 'user_profile_model.g.dart';

@JsonSerializable()
class UserProfileModel {
  final UserBetRecordModel userBetRecord;
  final List<FighterModel> alertFighters;
  final List<FighterFightEventModel> alertEvents;

  UserProfileModel({
    required this.userBetRecord,
    required this.alertFighters,
    required this.alertEvents,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json)
  => _$UserProfileModelFromJson(json);

}

@JsonSerializable()
class UserBetRecordModel {
  final int win;
  final int loss;
  final int noContest;

  UserBetRecordModel({
    required this.win,
    required this.loss,
    required this.noContest,
  });

  factory UserBetRecordModel.fromJson(Map<String, dynamic> json)
  => _$UserBetRecordModelFromJson(json);
}
