import 'package:json_annotation/json_annotation.dart';

part 'social_login_request.g.dart';

@JsonSerializable()
class SocialLoginRequest {
  final String domain;
  /// social login platform's accessToken
  final String accessToken;
  final String email;
  final String socialId;
  final String? fcmToken;

  SocialLoginRequest({
    required this.domain,
    required this.accessToken,
    required this.email,
    required this.socialId,
    required this.fcmToken,
  });

  Map<String, dynamic> toJson() => _$SocialLoginRequestToJson(this);
}
