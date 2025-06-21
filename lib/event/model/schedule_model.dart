import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mma_flutter/fighter/model/fighter_model.dart';

part 'schedule_model.g.dart';

@JsonSerializable()
class FightEventModel {
  final int id;
  final String name;

  // @JsonKey(fromJson: DataUtils.stringToDateTime)
  final DateTime date;
  final String location;
  final List<FighterFightEventModel> fighterFightEvents;

  FightEventModel({
    required this.id,
    required this.name,
    required this.date,
    required this.location,
    required this.fighterFightEvents,
  });

  factory FightEventModel.fromJson(Map<String, dynamic> json) =>
      _$FightEventModelFromJson(json);
}

@JsonSerializable()
class FighterFightEventModel {
  final String eventName;
  final String fightWeight;
  final FighterModel winner;
  final FighterModel loser;
  final FightResultModel result;

  FighterFightEventModel({
    required this.eventName,
    required this.fightWeight,
    required this.winner,
    required this.loser,
    required this.result,
  });

  factory FighterFightEventModel.fromJson(Map<String, dynamic> json) {
    try{
      return _$FighterFightEventModelFromJson(json);
    }catch(e,stackTrace){
      print(json);
      log('FighterFightEventModel json 변환 예외 발생', error: e, stackTrace: stackTrace);
      return _$FighterFightEventModelFromJson(json);
    }
  }
}

@JsonSerializable()
class FightResultModel {
  final String winMethod;
  final String winDescription;
  final int round;
  @JsonKey(fromJson: parseEndTime)
  final Duration endTime;

  FightResultModel({required this.winMethod, required this.winDescription, required this.round,required this.endTime});

  factory FightResultModel.fromJson(Map<String, dynamic> json) =>
      _$FightResultModelFromJson(json);
}

Duration parseEndTime(String time) {
  final parts = time.split(':');
  return Duration(
    minutes: int.parse(parts[0]),
    seconds: int.parse(parts[1]),
  );
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
