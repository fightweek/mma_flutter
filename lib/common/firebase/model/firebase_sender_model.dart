import 'package:json_annotation/json_annotation.dart';

part 'firebase_sender_model.g.dart';

@JsonSerializable()
class FirebaseSenderModel {
  final String token;
  final String category;
  final int categoryId;

  FirebaseSenderModel({
    required this.token,
    required this.category,
    required this.categoryId,
  });

  Map<String, dynamic> toJson() => _$FirebaseSenderModelToJson(this);
}