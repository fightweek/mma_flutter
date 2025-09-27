import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mma_flutter/stream/bet/model/single_bet_model.dart';
import 'package:mma_flutter/stream/chat/model/chat_response_model.dart';

final connectionCountProvider = StateProvider<int>((ref) => 0);
final chatResponseProvider = StateProvider<ChatResponseModel?>((ref) => null);
final betTargetProvider = StateProvider<List<SingleBetModel>>((ref) => []);