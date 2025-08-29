import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mma_flutter/common/model/base_state_model.dart';
import 'package:mma_flutter/stream/bet_and_vote/model/today_bet_response_model.dart';
import 'package:mma_flutter/stream/repository/stream_repository.dart';

final todayBetHistoryProvider = StateNotifierProvider<
  TodayBetHistoryStateNotifier,
  StateBase<TodayBetResponseModel>
>((ref) {
  final repository = ref.read(streamRepositoryProvider);
  return TodayBetHistoryStateNotifier(streamRepository: repository);
});

class TodayBetHistoryStateNotifier
    extends StateNotifier<StateBase<TodayBetResponseModel>> {
  final StreamRepository streamRepository;

  TodayBetHistoryStateNotifier({required this.streamRepository})
    : super(StateLoading<TodayBetResponseModel>()) {
    print('today bet history state notifier 생성됨');
    getTodayBetHistory();
  }

  Future<void> getTodayBetHistory() async {
    try {
      state = StateLoading<TodayBetResponseModel>();
      final resp = await streamRepository.getTodayBetHistory();
      state = StateData(data: resp);
    } catch (e,stackTrace) {
      print(e);
      print(stackTrace);
      state = StateError(message: 'error while requesting today bet history');
    }
  }
}