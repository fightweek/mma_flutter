import 'package:mma_flutter/common/model/model_with_id.dart';
import 'package:mma_flutter/fight_event/model/fight_event_model.dart';
import 'package:mma_flutter/fighter/model/fighter_model.dart';

abstract class IFighterFightEvent<T extends FighterModel> implements ModelWithId{
  @override
  final int id;
  final String fightWeight;
  final T winner;
  final T loser;
  final FightResultModel? result;
  final bool title;

  IFighterFightEvent({
    required this.id,
    required this.fightWeight,
    required this.winner,
    required this.loser,
    required this.result,
    required this.title,
  });
}
