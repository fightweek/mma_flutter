import 'package:json_annotation/json_annotation.dart';

part 'bet_request_model.g.dart';

@JsonSerializable()
class BetRequestModel {
  final String nickname;

  BetRequestModel({required this.nickname});

  Map<String, dynamic> toJson() => _$BetRequestModelToJson(this);
}
