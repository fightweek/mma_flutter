import 'package:json_annotation/json_annotation.dart';

part 'verify_code_request.g.dart';

@JsonSerializable()
class VerifyCodeRequest {
  final String email;
  final String verifyingCode;
  final String nickname;
  final String password;

  VerifyCodeRequest({
    required this.email,
    required this.verifyingCode,
    required this.nickname,
    required this.password,
  });

  Map<String, dynamic> toJson() => _$VerifyCodeRequestToJson(this);
}
