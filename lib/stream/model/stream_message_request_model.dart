import 'package:json_annotation/json_annotation.dart';
import 'package:mma_flutter/stream/chat/model/chat_request_model.dart';
import 'package:mma_flutter/stream/chat/model/join_request_model.dart';

part 'stream_message_request_model.g.dart';

@JsonSerializable()
class StreamMessageRequestModel {
  final RequestMessageType requestMessageType;
  final JoinRequestModel? chatJoinRequest;
  final ChatRequestModel? chatMessageRequest;
  final int? userIdToBlock;

  // final BetRequestModel? betRequest;

  StreamMessageRequestModel({
    required this.requestMessageType,
    // this.betRequest,
    this.chatMessageRequest,
    this.userIdToBlock,
    this.chatJoinRequest,
  });

  Map<String, dynamic> toJson() => _$StreamMessageRequestModelToJson(this);
}

@JsonEnum(alwaysCreate: true)
enum RequestMessageType {
  @JsonValue("BLOCK")
  block,
  @JsonValue("JOIN")
  join,
  @JsonValue("TALK")
  talk,
  @JsonValue("BET")
  bet,
}
