import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mma_flutter/stream/chat/model/chat_response_model.dart';
import 'package:mma_flutter/stream/model/stream_fight_event_model.dart';
import 'package:mma_flutter/stream/provider/stream_fight_event_provider.dart';

final connectionCountProvider = StateProvider<int>((ref) => 0);
final chatResponseProvider = StateProvider<ChatResponseModel?>((ref) => null);
