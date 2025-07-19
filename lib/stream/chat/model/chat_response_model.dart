import 'package:json_annotation/json_annotation.dart';

part 'chat_response_model.g.dart';

@JsonSerializable()
class ChatResponseModel {
  final String message;
  final String nickname;
  final int point;

  ChatResponseModel({
    required this.message,
    required this.nickname,
    required this.point,
  });

  factory ChatResponseModel.fromJson(Map<String, dynamic> json)
  => _$ChatResponseModelFromJson(json);

}
