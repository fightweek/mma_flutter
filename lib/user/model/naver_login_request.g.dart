// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'naver_login_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NaverLoginRequest _$NaverLoginRequestFromJson(Map<String, dynamic> json) =>
    NaverLoginRequest(
      naverAccessToken: json['naverAccessToken'] as String,
      email: json['email'] as String,
      socialId: json['socialId'] as String,
      nickname: json['nickname'] as String,
    );

Map<String, dynamic> _$NaverLoginRequestToJson(NaverLoginRequest instance) =>
    <String, dynamic>{
      'naverAccessToken': instance.naverAccessToken,
      'email': instance.email,
      'socialId': instance.socialId,
      'nickname': instance.nickname,
    };
