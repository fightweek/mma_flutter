import 'dart:developer';

import 'package:json_annotation/json_annotation.dart';
import 'package:mma_flutter/fight_event/model/abst/i_fight_event_model.dart';
import 'package:mma_flutter/fight_event/model/abst/i_fighter_fight_event_model.dart';
import 'package:mma_flutter/fight_event/model/card_date_time_info_model.dart';
import 'package:mma_flutter/fight_event/model/fight_event_model.dart';
import 'package:mma_flutter/fight_event/model/fighter_fight_event_detail_model.dart';

part 'stream_fight_event_model.g.dart';

@JsonSerializable()
class StreamFightEventModel extends IFightEventModel<StreamFighterFightEventModel>{

  StreamFightEventModel({
    required super.id,
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
      id: id,
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
    extends IFighterFightEvent<FighterFightEventFighterModel> {
  final StreamFighterFightEventStatus status;
  final double winnerVoteRate;
  final double loserVoteRate;

  StreamFighterFightEventModel({
    required this.status,
    required this.winnerVoteRate,
    required this.loserVoteRate,
    required super.id,
    required super.winner,
    required super.loser,
    required super.fightWeight,
    required super.result,
    required super.title,
    required super.eventName,
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
      eventName: eventName,
      winnerVoteRate: newWinnerVoteRate,
      loserVoteRate: newLoserVoteRate,
    );
  }
}

enum StreamFighterFightEventStatus {
  @JsonValue("PREVIOUS")
  previous,
  @JsonValue("NOW")
  now,
  @JsonValue("UPCOMING")
  upcoming,
}
