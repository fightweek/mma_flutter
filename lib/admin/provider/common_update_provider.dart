import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mma_flutter/admin/event/repository/admin_event_repository.dart';
import 'package:mma_flutter/admin/fighter/repository/admin_fighter_repository.dart';
import 'package:mma_flutter/admin/repository/updatable_repository.dart';
import 'package:mma_flutter/admin/stream/repository/admin_stream_repository.dart';
import 'package:mma_flutter/common/model/base_state_model.dart';

final adminEventUpdateProvider = StateNotifierProvider<CommonUpdateStateNotifier<AdminEventRepository>,StateBase<void>?>((ref) {
  return CommonUpdateStateNotifier(repository: ref.read(adminEventRepositoryProvider));
},);

final adminStreamUpdateProvider = StateNotifierProvider<CommonUpdateStateNotifier<AdminStreamRepository>,StateBase<void>?>((ref) {
  return CommonUpdateStateNotifier(repository: ref.read(adminStreamRepositoryProvider));
},);

final adminFighterUpdateProvider = StateNotifierProvider<CommonUpdateStateNotifier<AdminFighterRepository>,StateBase<void>?>((ref) {
  return CommonUpdateStateNotifier(repository: ref.read(adminFighterRepositoryProvider));
},);

class CommonUpdateStateNotifier<T extends UpdatableRepository> extends StateNotifier<StateBase<void>?> {
  final T repository;

  CommonUpdateStateNotifier({required this.repository}) : super(null);

  Future<void> update() async {
    try {
      state = StateLoading();
      await repository.update();
      state = StateData(data: null);
    } catch (e, stackTrace) {
      log(e.toString());
      log(stackTrace.toString());
      state = StateError(
        message:
            'error while ${T.toString()} message : ${stackTrace.toString()}',
      );
    }
  }
}
