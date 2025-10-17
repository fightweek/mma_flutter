import 'dart:developer';

import 'package:json_annotation/json_annotation.dart';
import 'package:mma_flutter/fight_event/model/i_fight_event_model.dart';
import 'package:mma_flutter/fight_event/model/i_fighter_fight_event_model.dart';
import 'package:mma_flutter/fighter/model/fighter_model.dart';

import 'card_date_time_info_model.dart';

part 'fight_event_model.g.dart';

@JsonSerializable()
class FightEventModel extends IFightEventModel<FighterFightEventModel> {
  final bool upcoming;
  final bool? alert;

  FightEventModel({
    required this.upcoming,
    required this.alert,
    required super.id,
    required super.name,
    required super.date,
    required super.mainCardDateTimeInfo,
    required super.prelimCardDateTimeInfo,
    required super.earlyCardDateTimeInfo,
    required super.mainCardCnt,
    required super.prelimCardCnt,
    required super.earlyCardCnt,
    required super.location,
    required super.fighterFightEvents,
  });

  factory FightEventModel.fromJson(Map<String, dynamic> json) =>
      _$FightEventModelFromJson(json);

  FightEventModel copyWith({bool? alert, bool? like}) {
    return FightEventModel(
      id: id,
      upcoming: upcoming,
      name: name,
      date: date,
      mainCardDateTimeInfo: mainCardDateTimeInfo,
      prelimCardDateTimeInfo: prelimCardDateTimeInfo,
      earlyCardDateTimeInfo: earlyCardDateTimeInfo,
      mainCardCnt: mainCardCnt,
      prelimCardCnt: prelimCardCnt,
      earlyCardCnt: earlyCardCnt,
      location: location,
      fighterFightEvents: fighterFightEvents,
      alert: alert,
    );
  }
}

@JsonSerializable()
class FighterFightEventModel extends IFighterFightEvent<FighterModel> {
  final int eventId;
  final String eventName;
  final DateTime eventDate;

  FighterFightEventModel({
    required this.eventId,
    required this.eventName,
    required this.eventDate,
    required super.fightWeight,
    required super.winner,
    required super.loser,
    required super.result,
    required super.id,
    required super.title,
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

@JsonSerializable()
class FightResultModel {
  final WinMethod? winMethod;
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

enum WinMethod {
  @JsonValue("SUB")
  sub,
  @JsonValue("KO_TKO")
  koTko,
  @JsonValue("U_DEC")
  uDec,
  @JsonValue("M_DEC")
  mDec,
  @JsonValue("S_DEC")
  sDec,
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
