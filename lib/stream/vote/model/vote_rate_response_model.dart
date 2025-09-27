import 'package:json_annotation/json_annotation.dart';

part 'vote_rate_response_model.g.dart';

@JsonSerializable()
class VoteRateResponseModel {
  final int ffeId;
  final double winnerVoteRate;
  final double loserVoteRate;

  VoteRateResponseModel({
    required this.ffeId,
    required this.winnerVoteRate,
    required this.loserVoteRate,
  });

  factory VoteRateResponseModel.fromJson(Map<String, dynamic> json) =>
      _$VoteRateResponseModelFromJson(json);
}
