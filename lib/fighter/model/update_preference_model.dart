import 'package:json_annotation/json_annotation.dart';

part 'update_preference_model.g.dart';

@JsonSerializable()
class UpdatePreferenceModel {
  final int targetId;
  final bool on;

  UpdatePreferenceModel({
    required this.targetId,
    required this.on,
  });

  Map<String, dynamic> toJson() => _$UpdatePreferenceModelToJson(this);
}

@JsonEnum(alwaysCreate: true)
enum PreferenceCategory {
  @JsonValue("LIKE")
  like,
  @JsonValue("ALERT")
  alert,
}
