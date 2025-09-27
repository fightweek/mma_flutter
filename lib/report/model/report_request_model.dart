import 'package:json_annotation/json_annotation.dart';

part 'report_request_model.g.dart';

@JsonSerializable()
class ReportRequestModel {
  final int reportedId;
  final ReportCategory reportCategory;

  ReportRequestModel({required this.reportedId, required this.reportCategory});

  Map<String,dynamic> toJson() => _$ReportRequestModelToJson(this);

}

enum ReportCategory {
  @JsonValue("SWEAR_WORD")
  swearWord,
  @JsonValue("THREAT")
  threat,
  @JsonValue("WRONG_INFO")
  wrongInfo,
  @JsonValue("IMPROPER_NICKNAME")
  improperNickname,
  @JsonValue("PERSONAL_INFO_LEAK")
  personalInfoLeak,
  @JsonValue("SEXUAL_WORD")
  sexualWord,
  @JsonValue("EXCESSIVE_COMMENT")
  excessiveComment,
}

extension ReportCategoryExtension on ReportCategory {
  String get label {
    switch (this) {
      case ReportCategory.swearWord:
        return '심한 욕설';
      case ReportCategory.threat:
        return '협박';
      case ReportCategory.wrongInfo:
        return '잘못된 정보';
      case ReportCategory.improperNickname:
        return '부적절한 닉네임';
      case ReportCategory.personalInfoLeak:
        return '개인 정보 유출';
      case ReportCategory.sexualWord:
        return '음란/성적 발언';
      case ReportCategory.excessiveComment:
        return '심한 댓글 도배';
    }
  }
}