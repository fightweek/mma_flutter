import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mma_flutter/common/model/base_state_model.dart';
import 'package:mma_flutter/stream/bet/model/bet_request_model.dart';
import 'package:mma_flutter/stream/bet/model/bet_response_model.dart';
import 'package:mma_flutter/stream/bet/repository/bet_repository.dart';
import 'package:mma_flutter/user/provider/user_provider.dart';

final betHistoryProvider = StateNotifierProvider.family<
  BetHistoryStateNotifier,
  Map<int, StateBase<BetResponseModel>>,
  int
>((ref, eventId) {
  final repository = ref.read(betRepositoryProvider);
  return BetHistoryStateNotifier(betRepository: repository, eventId: eventId);
});

final selectedBetHistoryEventIdProvider = StateProvider<int?>((ref) => null);

final betCreateFutureProvider = FutureProvider.autoDispose
    .family<void, BetRequestModel>((ref, request) async {
      final point = await ref.read(betRepositoryProvider).bet(request: request);
      ref.read(userProvider.notifier).updatePoint(point);
      ref
          .read(betHistoryProvider(request.eventId).notifier)
          .getBetHistory(forceRefetch: true);
    });

class BetHistoryStateNotifier
    extends StateNotifier<Map<int, StateBase<BetResponseModel>>> {
  final BetRepository betRepository;
  final int eventId;

  BetHistoryStateNotifier({required this.betRepository, required this.eventId})
    : super({eventId: StateLoading<BetResponseModel>()}) {
    print('bet history state notifier 생성됨');
    getBetHistory();
  }

  Future<void> deleteBet({
    required int betId,
    required int eventId,
    required int seedPoint,
    required int userPoint,
  }) async {
    try {
      state = {...state, eventId: StateLoading()};
      final resp = await betRepository.deleteBet(betId: betId);
      print(resp);
      state = {...state, eventId: StateData(data: resp)};
    } catch (e, stackTrace) {
      print(e);
      print(stackTrace);
      state = {
        ...state,
        eventId: StateError(message: 'error while deleting bet'),
      };
    }
  }

  Future<void> getBetHistory({bool forceRefetch = false}) async {
    try {
      if (!forceRefetch && state[eventId] is StateData) {
        return;
      }
      state = {...state, eventId: StateLoading<BetResponseModel>()};
      final resp = await betRepository.getBetHistory(eventId: eventId);
      state = {...state, eventId: StateData(data: resp)};
    } catch (e, stackTrace) {
      print(e);
      print(stackTrace);
      state = {
        ...state,
        eventId: StateError(message: 'error while requesting bet history'),
      };
    }
  }
}
