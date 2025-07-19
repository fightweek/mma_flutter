import 'dart:developer';

import 'package:json_annotation/json_annotation.dart';
import 'package:mma_flutter/fight_event/model/card_date_time_info_model.dart';
import 'package:mma_flutter/fight_event/model/fight_event_model.dart';
import 'package:mma_flutter/fighter/model/fighter_model.dart';

part 'stream_fight_event_model.g.dart';

@JsonSerializable()
class StreamFightEventModel {
  final String name;

  final DateTime eventDate;
  final CardDateTimeInfoModel? mainCardDateTimeInfo;
  final CardDateTimeInfoModel? prelimCardDateTimeInfo;
  final CardDateTimeInfoModel? earlyCardDateTimeInfo;

  final int? mainCardCnt;
  final int? prelimCardCnt;
  final int? earlyCardCnt;

  final String location;
  final List<StreamFighterFightEventModel> fighterFightEvents;

  StreamFightEventModel({
    required this.eventDate,
    required this.name,
    required this.mainCardDateTimeInfo,
    required this.prelimCardDateTimeInfo,
    required this.earlyCardDateTimeInfo,
    required this.mainCardCnt,
    required this.prelimCardCnt,
    required this.earlyCardCnt,
    required this.location,
    required this.fighterFightEvents,
  });

  factory StreamFightEventModel.fromJson(Map<String, dynamic> json) =>
      _$StreamFightEventModelFromJson(json);
}

@JsonSerializable()
class StreamFighterFightEventModel implements IFighterFightEvent<StreamFighterModel>{
  @override
  final String fightWeight;
  @override
  final FightResultModel? result;
  final StreamFighterFightEventStatus status;
  @override
  final StreamFighterModel winner;
  @override
  final StreamFighterModel loser;

  StreamFighterFightEventModel({
    required this.status,
    required this.winner,
    required this.loser,
    required this.fightWeight,
    required this.result,
  });

  factory StreamFighterFightEventModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$StreamFighterFightEventModelFromJson(json);
    } catch (e, stackTrace) {
      print(json);
      log(
        'FighterFightEventModel json 변환 예외 발생',
        error: e,
        stackTrace: stackTrace,
      );
      return _$StreamFighterFightEventModelFromJson(json);
    }
  }
}

@JsonSerializable()
class StreamFighterModel extends FighterModel {
  final int? reach;
  final DateTime birthday;
  final int height;
  final String bodyUrl;

  StreamFighterModel({
    required super.name,
    required super.nickname,
    required super.weight,
    required super.record,
    required super.ranking,
    required super.headshotUrl,
    required this.height,
    required super.id,
    required this.birthday,
    required this.reach,
    required this.bodyUrl,
  });

  factory StreamFighterModel.fromJson(Map<String, dynamic> json) =>
      _$StreamFighterModelFromJson(json);
}


enum StreamFighterFightEventStatus {
  @JsonValue("PREVIOUS")
  previous,
  @JsonValue("NOW")
  now,
  @JsonValue("UPCOMING")
  upcoming,
}
