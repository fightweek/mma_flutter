
import 'package:json_annotation/json_annotation.dart';

part 'vote_request_model.g.dart';

@JsonSerializable()
class VoteRequestModel {
  final int fighterFightEventId;
  final int winnerId;
  final int loserId;

  VoteRequestModel({
    required this.fighterFightEventId,
    required this.winnerId,
    required this.loserId,
  });

  Map<String, dynamic> toJson() => _$VoteRequestModelToJson(this);
}
