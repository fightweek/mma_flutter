import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mma_flutter/common/model/base_state_model.dart';
import 'package:mma_flutter/fighter/model/fighter_detail_model.dart';
import 'package:mma_flutter/fighter/model/fighter_model.dart';
import 'package:mma_flutter/fighter/model/update_preference_model.dart';
import 'package:mma_flutter/fighter/repository/fighter_repository.dart';

final fighterProvider = StateNotifierProvider<
  FighterStateNotifier,
  Map<int, StateBase<FighterModel>>
>((ref) {
  final fighterRepository = ref.read(fighterRepositoryProvider);
  return FighterStateNotifier(fighterRepository: fighterRepository);
});

class FighterStateNotifier
    extends StateNotifier<Map<int, StateBase<FighterModel>>> {
  final FighterRepository fighterRepository;

  FighterStateNotifier({required this.fighterRepository}) : super({});

  ///
  void updateFighter(FighterModel model) {
    try {
      if (state[model.id] == null) {
        print('updateFighter ${model.name}');
        state = {...state, model.id: StateData(data: model)};
      } else {
        print('already updated, name : ${model.name}');
        return;
      }
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

  Future<void> detail({required int id, bool forceRefetch = false}) async {
    try {
      if (!forceRefetch && state[id] is StateData) {
        final fState = state[id] as StateData;
        if (fState.data is FighterDetailModel) {
          print('already fetched detail data');
          return;
        }
      }
      state = {...state, id: StateLoading()};
      final resp = await fighterRepository.detail(fighterId: id);
      state = {...state, id: StateData<FighterDetailModel>(data: resp)};
      resp.fighterFightEvents?.forEach((e) {
        if (e.winner.id != id) {
          updateFighter(e.winner);
        }
        if (e.loser.id != id) {
          updateFighter(e.loser);
        }
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

  Future<Map<String, String>> getHeadshotUrl({required String name}) async {
    final url = await fighterRepository.getHeadshotUrl(name: name);
    return url;
  }

  Future<void> updatePreference({
    required UpdatePreferenceModel model,
    bool? alert,
    bool? like,
  }) async {
    print(state[model.targetId]);
    fighterRepository.updatePreference(request: model);
    final fState = state[model.targetId] as StateData<FighterDetailModel>;
    state = {
      ...state,
      model.targetId: StateData<FighterDetailModel>(
        data: fState.data?.copyWith(alert: alert, like: like),
      ),
    };
  }
}
