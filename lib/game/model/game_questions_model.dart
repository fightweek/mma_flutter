import 'package:json_annotation/json_annotation.dart';
import 'package:mma_flutter/fight_event/model/fight_event_model.dart';

part 'game_questions_model.g.dart';

class GameQuestionsModel {
}

@JsonSerializable()
class GameQuestionModel {
  final GameCategory gameCategory;
  final String name;
  final String? nickname;
  final int? ranking;
  final String? rankingCategory;
  final String? bodyUrl;
  final String? headshotUrl;
  final FightRecordModel? fightRecord;
  final List<String> namesForSelection;

  GameQuestionModel({
    required this.gameCategory,
    required this.name,
    required this.nickname,
    required this.ranking,
    required this.rankingCategory,
    required this.bodyUrl,
    required this.headshotUrl,
    required this.fightRecord,
    required this.namesForSelection,
  });

}

enum GameCategory {
  @JsonValue('HEADSHOT')
  headshot,
  @JsonValue('BODY')
  body,
  @JsonValue('NICKNAME')
  nickname,
  @JsonValue('RANKING')
  ranking,
  @JsonValue('RECORD')
  record
}