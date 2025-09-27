import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mma_flutter/common/model/base_state_model.dart';
import 'package:mma_flutter/fighter/provider/fighter_provider.dart';
import 'package:mma_flutter/stream/bet/model/bet_request_model.dart';
import 'package:mma_flutter/stream/model/stream_fight_event_model.dart';
import 'package:mma_flutter/stream/repository/stream_fight_event_repository.dart';
import 'package:mma_flutter/stream/vote/model/vote_rate_response_model.dart';
import 'package:mma_flutter/stream/vote/model/vote_request_model.dart';
import 'package:mma_flutter/user/provider/user_provider.dart';

final streamFightEventProvider = StateNotifierProvider<
  StreamStateNotifier,
  StateBase<StreamFightEventModel>
>((ref) {
  final repository = ref.read(streamFightEventRepositoryProvider);
  return StreamStateNotifier(ref: ref, streamFightEventRepository: repository);
});

class StreamStateNotifier
    extends StateNotifier<StateBase<StreamFightEventModel>> {
  final StreamFightEventRepository streamFightEventRepository;
  final Ref ref;

  StreamStateNotifier({
    required this.ref,
    required this.streamFightEventRepository,
  }) : super(StateLoading()) {
    print('StreamStateNotifier 생성됨');
    getCurrentFightEventInfo();
  }

  Future<void> getCurrentFightEventInfo() async {
    try {
      final resp = await streamFightEventRepository.getFightEvent();
      resp.fighterFightEvents.forEach((e) {
        ref.read(fighterProvider.notifier).updateFighter(e.winner);
        ref.read(fighterProvider.notifier).updateFighter(e.loser);
      });
      state = StateData(data: resp);
    } catch (e, stackTrace) {
      print(e);
      print(stackTrace);
      state = StateError(message: 'error while getting current fight event info');
    }
  }

  void update(StreamFightEventModel model) {
    state = StateData(data: model);
  }

  void updateVoteRate(VoteRateResponseModel model) {
    if (state is! StateData<StreamFightEventModel>) {
      print('state is not StateData, but ${state.runtimeType}');
      return;
    }
    print('update vote rate!');
    final currentState = state as StateData<StreamFightEventModel>;
    final oldData = currentState.data!;
    final updatedFfe =
        oldData.fighterFightEvents.map((ffe) {
          if (ffe.id == model.ffeId) {
            return ffe.copyWith(
              newWinnerVoteRate: model.winnerVoteRate,
              newLoserVoteRate: model.loserVoteRate,
            );
          }
          return ffe;
        }).toList();
    state = StateData(data: oldData.copyWith(ffes: updatedFfe));
  }
}
