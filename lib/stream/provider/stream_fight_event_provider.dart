import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mma_flutter/common/model/base_state_model.dart';
import 'package:mma_flutter/stream/model/stream_fight_event_model.dart';
import 'package:mma_flutter/stream/repository/stream_repository.dart';

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
      final resp = await ref.read(streamRepositoryProvider).getFightEvent(eventName: Uri.encodeComponent("Holloway vs Poirier 3"));
      state = StateData(data: resp);
    } catch (e) {
      state = StateError(message: 'stream get current fight event info error');
    }
  }

  Future<void> update(StreamFightEventModel model) async {
    state = StateData(data: model);
  }
}
