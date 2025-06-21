import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mma_flutter/common/model/base_state.dart';
import 'package:mma_flutter/fighter/model/fighter_detail_model.dart';
import 'package:mma_flutter/fighter/model/fighter_model.dart';
import 'package:mma_flutter/fighter/repository/fighter_repository.dart';

final fighterDetailProvider = Provider.family<StateBase<FighterModel>?, int>((
  ref,
  id,
) {
  final state = ref.watch(fighterProvider(id));
  return state[id];
});

final fighterProvider = StateNotifierProvider.family<
  FighterStateNotifier,
  Map<int, StateBase<FighterModel>>,
  int
>((ref, id) {
  final fighterRepository = ref.read(fighterRepositoryProvider);
  return FighterStateNotifier(fighterRepository: fighterRepository, id: id);
});

class FighterStateNotifier
    extends StateNotifier<Map<int, StateBase<FighterModel>>> {
  final int id;
  final FighterRepository fighterRepository;

  FighterStateNotifier({required this.id, required this.fighterRepository})
    : super({});

  void updateFighter(FighterModel model) {
    try {
      state = {...state, id: StateData(data: model)};
    } catch (e, stack) {
      print('error occurred while updating fighter state');
      print('예외 발생: $e');
      print('스택: $stack');
      state = {
        ...state,
        id: StateError(message: 'error while updating fighter data'),
      };
    }
  }

  Future<void> detail() async {
    try {
      final fState = state[id] as StateData;
      if(fState.data is FighterDetailModel){
        print('already fetched detail data');
        return;
      }
      // state = {...state, id: StateLoading()};
      final resp = await fighterRepository.detail(fighterId: id);
      state = {...state, id: StateData(data: resp)};
    } catch (e, stack) {
      print('예외 발생: $e');
      print('스택: $stack');
      state = {
        ...state,
        id: StateError(message: 'error while fetching fighter data'),
      };
    }
  }
}
