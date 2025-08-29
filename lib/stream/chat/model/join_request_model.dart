import 'package:json_annotation/json_annotation.dart';

part 'join_request_model.g.dart';

@JsonSerializable()
class JoinRequestModel {
  final int userId;
  final String nickname;

  JoinRequestModel({required this.userId, required this.nickname});

  Map<String, dynamic> toJson() => _$JoinRequestModelToJson(this);
}
