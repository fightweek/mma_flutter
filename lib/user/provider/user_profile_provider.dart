import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mma_flutter/common/model/base_state_model.dart';
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
    : super(StateLoading()){
    profile();
  }

  void profile() async{
    try{
      state = StateLoading();
      final resp = await userRepository.profile();
      state = StateData(data: resp);
    }catch(e,stack){
      print(e);
      print(stack);
      state = StateError(message: 'error while getting user profile data');
    }
  }

}
