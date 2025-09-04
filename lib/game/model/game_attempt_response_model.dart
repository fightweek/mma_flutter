import 'package:json_annotation/json_annotation.dart';

part 'game_attempt_response_model.g.dart';

@JsonSerializable()
class GameAttemptResponseModel {
  final int count;
  final int adCount;

  GameAttemptResponseModel({required this.count, required this.adCount});

  factory GameAttemptResponseModel.fromJson(Map<String, dynamic> json)
  => _$GameAttemptResponseModelFromJson(json);
}
