import 'package:json_annotation/json_annotation.dart';

part 'verify_code_request.g.dart';

@JsonSerializable()
class VerifyCodeRequest {
  final String email;
  final String verifyingCode;

  VerifyCodeRequest({
    required this.email,
    required this.verifyingCode,
  });

  Map<String, dynamic> toJson() => _$VerifyCodeRequestToJson(this);
}
