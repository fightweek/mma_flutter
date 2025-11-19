import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mma_flutter/common/model/pagination_model.dart';
import 'package:mma_flutter/common/provider/pagination_notifier.dart';
import 'package:mma_flutter/fight_event/model/fight_event_model.dart';
import 'package:mma_flutter/fight_event/repository/fight_event_repository.dart';

final fightEventPaginationProvider =
StateNotifierProvider<FightEventPaginationStateNotifier, PaginationBase>((
    ref,
    ) {
  final repo = ref.read(fightEventRepositoryProvider);
  return FightEventPaginationStateNotifier(repository: repo);
});

class FightEventPaginationStateNotifier
    extends PaginationNotifier<FighterFightEventModel, FightEventRepository> {
  FightEventPaginationStateNotifier({required super.repository});
}
