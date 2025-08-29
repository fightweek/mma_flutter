import 'package:json_annotation/json_annotation.dart';

part 'image_game_questions_model.g.dart';

@JsonSerializable()
class ImageGameQuestionsModel {
  final List<ImageGameQuestionModel> gameQuestions;

  ImageGameQuestionsModel({required this.gameQuestions});

  factory ImageGameQuestionsModel.fromJson(Map<String, dynamic> json)
  => _$ImageGameQuestionsModelFromJson(json);
}

@JsonSerializable()
class ImageGameQuestionModel {
  final String name;
  final String answerImgUrl;
  final List<String> wrongSelection;

  ImageGameQuestionModel({
    required this.name,
    required this.answerImgUrl,
    required this.wrongSelection,
  });

  factory ImageGameQuestionModel.fromJson(Map<String, dynamic> json)
  => _$ImageGameQuestionModelFromJson(json);
}
