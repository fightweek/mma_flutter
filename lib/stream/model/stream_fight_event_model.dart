import 'dart:developer';

import 'package:json_annotation/json_annotation.dart';
import 'package:mma_flutter/fight_event/model/card_date_time_info_model.dart';
import 'package:mma_flutter/fight_event/model/fight_event_model.dart';
import 'package:mma_flutter/fight_event/model/i_fight_event_model.dart';
import 'package:mma_flutter/fight_event/model/i_fighter_fight_event_model.dart';
import 'package:mma_flutter/fighter/model/fighter_model.dart';

part 'stream_fight_event_model.g.dart';

@JsonSerializable()
class StreamFightEventModel extends IFightEventModel<StreamFighterFightEventModel>{

  StreamFightEventModel({
    required super.date,
    required super.name,
    required super.mainCardDateTimeInfo,
    required super.prelimCardDateTimeInfo,
    required super.earlyCardDateTimeInfo,
    required super.mainCardCnt,
    required super.prelimCardCnt,
    required super.earlyCardCnt,
    required super.location,
    required super.fighterFightEvents,
  });

  StreamFightEventModel copyWith({
    required List<StreamFighterFightEventModel> ffes,
  }) {
    return StreamFightEventModel(
      date: date,
      name: name,
      mainCardDateTimeInfo: mainCardDateTimeInfo,
      prelimCardDateTimeInfo: prelimCardDateTimeInfo,
      earlyCardDateTimeInfo: earlyCardDateTimeInfo,
      mainCardCnt: mainCardCnt,
      prelimCardCnt: prelimCardCnt,
      earlyCardCnt: earlyCardCnt,
      location: location,
      fighterFightEvents: ffes,
    );
  }

  factory StreamFightEventModel.fromJson(Map<String, dynamic> json) =>
      _$StreamFightEventModelFromJson(json);
}

@JsonSerializable()
class StreamFighterFightEventModel
    implements IFighterFightEvent<StreamFighterModel> {
  @override
  final int id;
  @override
  final String fightWeight;
  @override
  final FightResultModel? result;
  @override
  final StreamFighterModel winner;
  @override
  final StreamFighterModel loser;
  @override
  final bool title;
  final StreamFighterFightEventStatus status;
  final double winnerVoteRate;
  final double loserVoteRate;

  StreamFighterFightEventModel({
    required this.id,
    required this.status,
    required this.winner,
    required this.loser,
    required this.fightWeight,
    required this.result,
    required this.winnerVoteRate,
    required this.loserVoteRate,
    required this.title,
  });

  factory StreamFighterFightEventModel.fromJson(Map<String, dynamic> json) {
    // log(json.toString());
    try {
      return _$StreamFighterFightEventModelFromJson(json);
    } catch (e, stackTrace) {
      log(
        'FighterFightEventModel json 변환 예외 발생',
        error: e,
        stackTrace: stackTrace,
      );
      return _$StreamFighterFightEventModelFromJson(json);
    }
  }

  StreamFighterFightEventModel copyWith({
    required double newWinnerVoteRate,
    required double newLoserVoteRate,
  }) {
    return StreamFighterFightEventModel(
      id: id,
      status: status,
      winner: winner,
      loser: loser,
      fightWeight: fightWeight,
      result: result,
      title: title,
      winnerVoteRate: newWinnerVoteRate,
      loserVoteRate: newLoserVoteRate,
    );
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
