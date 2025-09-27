import 'package:json_annotation/json_annotation.dart';

part 'join_request.g.dart';

@JsonSerializable()
class JoinRequest {
  final String email;
  final String nickname;
  final String password;

  JoinRequest({
    required this.email,
    required this.nickname,
    required this.password,
  });

  Map<String, dynamic> toJson() => _$JoinRequestToJson(this);
}
