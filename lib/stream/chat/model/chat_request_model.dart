import 'package:json_annotation/json_annotation.dart';

part 'chat_request_model.g.dart';

@JsonSerializable()
class ChatRequestModel {
  final String message;
  final int point;

  ChatRequestModel({required this.message, required this.point});

  Map<String,dynamic> toJson() => _$ChatRequestModelToJson(this);

}
