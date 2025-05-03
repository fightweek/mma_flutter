import 'package:json_annotation/json_annotation.dart';

part 'naver_login_request.g.dart';

@JsonSerializable()
class SocialLoginRequest {
  final String domain;
  final String accessToken;
  final String email;
  final String socialId;
  final String nickname;

  SocialLoginRequest({
    required this.domain,
    required this.accessToken,
    required this.email,
    required this.socialId,
    required this.nickname,
  });

  Map<String, dynamic> toJson() => _$SocialLoginRequestToJson(this);
}
