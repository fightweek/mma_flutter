import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mma_flutter/common/model/base_state_model.dart';
import 'package:mma_flutter/fighter/provider/fighter_provider.dart';
import 'package:mma_flutter/stream/bet_and_vote/model/bet_request_model.dart';
import 'package:mma_flutter/stream/bet_and_vote/model/vote_rate_response_model.dart';
import 'package:mma_flutter/stream/bet_and_vote/model/vote_request_model.dart';
import 'package:mma_flutter/stream/model/stream_fight_event_model.dart';
import 'package:mma_flutter/stream/repository/stream_repository.dart';
import 'package:mma_flutter/user/provider/user_provider.dart';

final streamFightEventProvider = StateNotifierProvider<
  StreamStateNotifier,
  StateBase<StreamFightEventModel>
>((ref) {
  final repository = ref.read(streamRepositoryProvider);
  return StreamStateNotifier(ref: ref, streamFightEventRepository: repository);
});

class StreamStateNotifier
    extends StateNotifier<StateBase<StreamFightEventModel>> {
  final StreamRepository streamFightEventRepository;
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
      state = StateError(message: 'stream get current fight event info error');
    }
  }

  Future<void> vote(VoteRequestModel request) async {
    try {
      final resp = await streamFightEventRepository.vote(request: request);
      if (resp != null) {
        updateVoteRate(resp);
      }
    } catch (e, stack) {
      print(e);
      print(stack);
      state = StateError(message: 'error while requesting vote');
    }
  }

  Future<void> bet(BetRequestModel request) async {
    try {
      final resp = await streamFightEventRepository.bet(request: request);
      ref.read(userProvider.notifier).updatePoint(resp);
    } catch (e) {
      state = StateError(message: 'error while requesting bet');
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
