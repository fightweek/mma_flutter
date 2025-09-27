import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

abstract class UserModelBase {}

class UserModelError extends UserModelBase {
  final String message;

  UserModelError({required this.message});
}

class UserModelLoading extends UserModelBase {}

class UserModelLoadingToHome extends UserModelBase {}

class UserModelNicknameSetting extends UserModelBase {}

@JsonSerializable()
class UserModel extends UserModelBase {
  final String role;
  final int id;
  final String? nickname;
  final String email;
  final int point;

  UserModel({
    required this.point,
    required this.role,
    required this.id,
    required this.nickname,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
