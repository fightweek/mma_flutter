// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_code_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyCodeRequest _$VerifyCodeRequestFromJson(Map<String, dynamic> json) =>
    VerifyCodeRequest(
      email: json['email'] as String,
      verifyingCode: json['verifyingCode'] as String,
      nickname: json['nickname'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$VerifyCodeRequestToJson(VerifyCodeRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
      'verifyingCode': instance.verifyingCode,
      'nickname': instance.nickname,
      'password': instance.password,
    };
