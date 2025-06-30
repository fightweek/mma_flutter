import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mma_flutter/common/model/base_state_model.dart';
import 'package:mma_flutter/fighter/model/fighter_detail_model.dart';
import 'package:mma_flutter/fighter/model/fighter_model.dart';
import 'package:mma_flutter/fighter/model/update_preference_model.dart';
import 'package:mma_flutter/fighter/repository/fighter_repository.dart';

final fighterProvider = StateNotifierProvider<FighterStateNotifier, Map<int, StateBase<FighterModel>>>((ref) {
  final fighterRepository = ref.read(fighterRepositoryProvider);
  return FighterStateNotifier(fighterRepository: fighterRepository);
});

class FighterStateNotifier
    extends StateNotifier<Map<int, StateBase<FighterModel>>> {
  final FighterRepository fighterRepository;

  FighterStateNotifier({required this.fighterRepository})
    : super({});

  void updateFighter(FighterModel model) {
    try {
      if(state[model.id] is StateData){
        print('already updated, name : ${model.name}');
        return;
      }
      print('updateFighter ${model.name}');
      state = {...state, model.id: StateData(data: model)};
    } catch (e, stack) {
      print('error occurred while updating fighter state');
      print('예외 발생: $e');
      print('스택: $stack');
      state = {
        ...state,
        model.id: StateError(message: 'error while updating fighter data'),
      };
    }
  }

  Future<void> detail(int id) async {
    try {
      final fState = state[id] as StateData;
      // if (fState.data is FighterDetailModel) {
      //   print('already fetched detail data');
      //   return;
      // }
      state = {...state, id: StateLoading()};
      final resp = await fighterRepository.detail(fighterId: id);
      state = {...state, id: StateData(data: resp)};
      resp.fighterFightEvents?.forEach((e) {
        updateFighter(e.winner);
        updateFighter(e.loser);
      });
    } catch (e, stack) {
      print('예외 발생: $e');
      print('스택: $stack');
      state = {
        ...state,
        id: StateError(message: 'error while fetching fighter data'),
      };
    }
  }

  Future<void> updatePreference(UpdatePreferenceModel model) async {
    fighterRepository.updatePreference(request: model);
  }
}
