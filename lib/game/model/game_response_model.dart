import 'package:json_annotation/json_annotation.dart';
import 'package:mma_flutter/game/model/image_game_questions_model.dart';
import 'package:mma_flutter/game/model/name_game_questions_model.dart';

part 'game_response_model.g.dart';

@JsonSerializable()
class GameResponseModel {
  final NameGameQuestionsModel? nameGameQuestions;
  final ImageGameQuestionsModel? imageGameQuestions;

  GameResponseModel({
    required this.nameGameQuestions,
    required this.imageGameQuestions,
  });

  factory GameResponseModel.fromJson(Map<String, dynamic> json)
  => _$GameResponseModelFromJson(json);
}
