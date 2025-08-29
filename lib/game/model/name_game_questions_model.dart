import 'package:json_annotation/json_annotation.dart';
import 'package:mma_flutter/fight_event/model/fight_event_model.dart';

part 'game_questions_model.g.dart';

@JsonSerializable()
class NameGameQuestionsModel {
  final List<NameGameQuestionModel> gameQuestions;

  NameGameQuestionsModel({required this.gameQuestions});

  factory NameGameQuestionsModel.fromJson(Map<String, dynamic> json)
  => _$GameQuestionsModelFromJson(json);
}

@JsonSerializable()
class NameGameQuestionModel {
  final GameCategory gameCategory;
  final String answerName;
  final String? nickname;
  final int? ranking;
  final String? rankingCategory;
  final String? bodyUrl;
  final String? headshotUrl;
  final FightRecordModel? fightRecord;
  final List<String> wrongSelection;

  NameGameQuestionModel({
    required this.gameCategory,
    required this.answerName,
    required this.nickname,
    required this.ranking,
    required this.rankingCategory,
    required this.bodyUrl,
    required this.headshotUrl,
    required this.fightRecord,
    required this.wrongSelection,
  });

  factory NameGameQuestionModel.fromJson(Map<String, dynamic> json)
  => _$GameQuestionModelFromJson(json);
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
  record,
}


extension GameCategoryExtension on GameCategory {
  String get label {
    switch (this) {
      case GameCategory.headshot:case GameCategory.body:
        return '사진';
      case GameCategory.record:
        return '전적';
      case GameCategory.ranking:
        return '랭킹';
      case GameCategory.nickname:
        return '닉네임';
    }
  }
}
