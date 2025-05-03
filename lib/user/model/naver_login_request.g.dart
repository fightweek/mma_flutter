// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'naver_login_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SocialLoginRequest _$SocialLoginRequestFromJson(Map<String, dynamic> json) =>
    SocialLoginRequest(
      domain: json['domain'] as String,
      accessToken: json['accessToken'] as String,
      email: json['email'] as String,
      socialId: json['socialId'] as String,
      nickname: json['nickname'] as String,
    );

Map<String, dynamic> _$SocialLoginRequestToJson(SocialLoginRequest instance) =>
    <String, dynamic>{
      'domain': instance.domain,
      'accessToken': instance.accessToken,
      'email': instance.email,
      'socialId': instance.socialId,
      'nickname': instance.nickname,
    };
