import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mma_flutter/common/model/base_state_model.dart';
import 'package:mma_flutter/fight_event/model/fight_event_model.dart';
import 'package:mma_flutter/fighter/model/fighter_model.dart';
import 'package:mma_flutter/user/model/user_profile_model.dart';
import 'package:mma_flutter/user/repository/user_repository.dart';

final userProfileProvider = StateNotifierProvider<
  UserProfileStateNotifier,
  StateBase<UserProfileModel>
>((ref) {
  final userRepository = ref.read(userRepositoryProvider);
  return UserProfileStateNotifier(userRepository: userRepository);
});

class UserProfileStateNotifier
    extends StateNotifier<StateBase<UserProfileModel>> {
  final UserRepository userRepository;

  UserProfileStateNotifier({required this.userRepository})
    : super(StateLoading()) {
    profile();
  }

  void profile() async {
    try {
      state = StateLoading();
      final resp = await userRepository.profile();
      state = StateData(data: resp);
    } catch (e, stack) {
      print(e);
      print(stack);
      state = StateError(message: 'error while getting user profile data');
    }
  }

  void deleteCard({
    FighterModel? fighterCardToDelete,
    FighterFightEventModel? fighterFightEventCardToDelete,
  }) {
    final currentState = state as StateData<UserProfileModel>;
    if (fighterCardToDelete != null) {
      currentState.data!.alertFighters.remove(fighterCardToDelete);
    } else {
      currentState.data!.alertEvents.remove(fighterFightEventCardToDelete);
    }
    final newData = currentState.data!.copyWith(
      newAlertFighters: currentState.data!.alertFighters,
      newAlertEvents: currentState.data!.alertEvents,
    );
    state = StateData(data: newData);
  }
}
