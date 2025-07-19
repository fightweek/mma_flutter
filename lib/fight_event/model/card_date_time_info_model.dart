import 'package:json_annotation/json_annotation.dart';

part 'card_date_time_info_model.g.dart';

@JsonSerializable()
class CardDateTimeInfoModel {

  final DateTime date;

  @JsonKey(fromJson: parseCardStartTime)
  final Duration time;

  CardDateTimeInfoModel({required this.date, required this.time});

  factory CardDateTimeInfoModel.fromJson(Map<String, dynamic> json)
  => _$CardDateTimeInfoModelFromJson(json);

}

Duration parseCardStartTime(String time) {
  final parts = time.split(':');
  return Duration(
    hours: int.parse(parts[0]),
    minutes: int.parse(parts[1]),
  );
}
