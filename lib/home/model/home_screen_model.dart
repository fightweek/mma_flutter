import 'package:json_annotation/json_annotation.dart';
import 'package:mma_flutter/fight_event/model/card_date_time_info_model.dart';

part 'home_screen_model.g.dart';

@JsonSerializable()
class HomeScreenModel {
  final String eventName;
  final String winnerBodyUrl;
  final String loserBodyUrl;
  final CardDateTimeInfoModel? mainCardDateTimeInfo;
  final String winnerName;
  final String loserName;
  final String fightWeight;
  final bool title;
  final bool now;

  HomeScreenModel({
    required this.eventName,
    required this.winnerBodyUrl,
    required this.loserBodyUrl,
    required this.mainCardDateTimeInfo,
    required this.winnerName,
    required this.loserName,
    required this.fightWeight,
    required this.title,
    required this.now,
  });

  factory HomeScreenModel.fromJson(Map<String, dynamic> json)
  => _$HomeScreenModelFromJson(json);
}
