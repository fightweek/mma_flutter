import 'package:json_annotation/json_annotation.dart';
import 'package:mma_flutter/stream/bet_and_vote/model/bet_request_model.dart';

part 'today_bet_response_model.g.dart';

@JsonSerializable()
class TodayBetResponseModel {
  final List<SingleBetResponseModel> singleBets;

  TodayBetResponseModel({required this.singleBets});

  factory TodayBetResponseModel.fromJson(Map<String, dynamic> json)
  => _$TodayBetResponseModelFromJson(json);

}

@JsonSerializable()
class SingleBetResponseModel {
  final List<SingleBetCardResponseModel> betCards;
  final bool? succeed;
  final DateTime createdDateTime;

  SingleBetResponseModel({
    required this.betCards,
    required this.succeed,
    required this.createdDateTime,
  });

  factory SingleBetResponseModel.fromJson(Map<String, dynamic> json)
  => _$SingleBetResponseModelFromJson(json);
}

@JsonSerializable()
class SingleBetCardResponseModel {
  final BetPredictionModel betPrediction;
  final bool? succeed;
  final int seedPoint;

  SingleBetCardResponseModel({
    required this.betPrediction,
    required this.succeed,
    required this.seedPoint,
  });

  factory SingleBetCardResponseModel.fromJson(Map<String, dynamic> json)
  => _$SingleBetCardResponseModelFromJson(json);

}
