import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mma_flutter/common/model/pagination_model.dart';
import 'package:mma_flutter/common/provider/pagination_provider.dart';
import 'package:mma_flutter/fighter/model/fighter_model.dart';
import 'package:mma_flutter/fighter/repository/fighter_repository.dart';

final fighterPaginationProvider =
    StateNotifierProvider<FighterPaginationStateNotifier, PaginationBase>((
      ref,
    ) {
      final repo = ref.read(fighterRepositoryProvider);
      return FighterPaginationStateNotifier(repository: repo);
    });

class FighterPaginationStateNotifier
    extends PaginationProvider<FighterModel, FighterRepository> {
  FighterPaginationStateNotifier({required super.repository});
}
