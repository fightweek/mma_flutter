import 'package:json_annotation/json_annotation.dart';

part 'naver_login_request.g.dart';

@JsonSerializable()
class NaverLoginRequest {
  final String naverAccessToken;
  final String email;
  final String socialId;
  final String nickname;

  NaverLoginRequest({
    required this.naverAccessToken,
    required this.email,
    required this.socialId,
    required this.nickname,
  });

  Map<String, dynamic> toJson() => _$NaverLoginRequestToJson(this);
}
