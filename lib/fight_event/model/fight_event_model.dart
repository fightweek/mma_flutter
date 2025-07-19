import 'dart:developer';

import 'package:json_annotation/json_annotation.dart';
import 'package:mma_flutter/fighter/model/fighter_model.dart';

import 'card_date_time_info_model.dart';

part 'fight_event_model.g.dart';

@JsonSerializable()
class FightEventModel {
  final int id;
  final String name;

  // @JsonKey(fromJson: DataUtils.stringToDateTime)
  final DateTime date;

  final CardDateTimeInfoModel? mainCardDateTimeInfo;
  final CardDateTimeInfoModel? prelimCardDateTimeInfo;
  final CardDateTimeInfoModel? earlyCardDateTimeInfo;

  final int? mainCardCnt;
  final int? prelimCardCnt;
  final int? earlyCardCnt;

  final String location;
  final List<FighterFightEventModel> fighterFightEvents;
  final bool upcoming;

  FightEventModel({
    required this.id,
    required this.name,
    required this.date,
    required this.mainCardDateTimeInfo,
    required this.prelimCardDateTimeInfo,
    required this.earlyCardDateTimeInfo,
    required this.mainCardCnt,
    required this.prelimCardCnt,
    required this.earlyCardCnt,
    required this.location,
    required this.fighterFightEvents,
    required this.upcoming,
  });

  factory FightEventModel.fromJson(Map<String, dynamic> json) =>
      _$FightEventModelFromJson(json);
}

@JsonSerializable()
class FighterFightEventModel implements IFighterFightEvent<FighterModel>{
  final String eventName;
  final DateTime eventDate;
  @override
  final String fightWeight;
  @override
  final FighterModel loser;
  @override
  final FighterModel winner;
  @override
  final FightResultModel? result;

  FighterFightEventModel({
    required this.eventName,
    required this.eventDate,
    required this.fightWeight,
    required this.winner,
    required this.loser,
    required this.result,
  });

  factory FighterFightEventModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$FighterFightEventModelFromJson(json);
    } catch (e, stackTrace) {
      print(json);
      log(
        'FighterFightEventModel json 변환 예외 발생',
        error: e,
        stackTrace: stackTrace,
      );
      return _$FighterFightEventModelFromJson(json);
    }
  }
}

abstract class IFighterFightEvent<T extends FighterModel> {
  String get fightWeight;
  T get winner;
  T get loser;
  FightResultModel? get result;
}

@JsonSerializable()
class FightResultModel {
  final String winMethod;
  final String? description;
  final int round;
  @JsonKey(fromJson: parseEndTime)
  final Duration endTime;

  FightResultModel({
    required this.winMethod,
    required this.description,
    required this.round,
    required this.endTime,
  });

  factory FightResultModel.fromJson(Map<String, dynamic> json) =>
      _$FightResultModelFromJson(json);
}

Duration parseEndTime(String time) {
  final parts = time.split(':');
  return Duration(minutes: int.parse(parts[0]), seconds: int.parse(parts[1]));
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
