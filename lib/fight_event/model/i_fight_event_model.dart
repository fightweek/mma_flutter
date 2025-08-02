import 'package:mma_flutter/fight_event/model/card_date_time_info_model.dart';
import 'package:mma_flutter/fight_event/model/fight_event_model.dart';
import 'package:mma_flutter/fight_event/model/i_fighter_fight_event_model.dart';

abstract class IFightEventModel<T extends IFighterFightEvent> {
  final String name;

  // @JsonKey(fromJson: DataUtils.stringToDateTime)
  final DateTime date;

  final CardDateTimeInfoModel? mainCardDateTimeInfo;
  final CardDateTimeInfoModel? prelimCardDateTimeInfo;
  final CardDateTimeInfoModel? earlyCardDateTimeInfo;

  final int? mainCardCnt;
  final int? prelimCardCnt;
  final int? earlyCardCnt;

  final String location;
  final List<T> fighterFightEvents;

  IFightEventModel({
    required this.name,
    required this.date,
    required this.mainCardDateTimeInfo,
    required this.prelimCardDateTimeInfo,
    required this.earlyCardDateTimeInfo,
    required this.mainCardCnt,
    required this.prelimCardCnt,
    required this.earlyCardCnt,
    required this.location,
    required this.fighterFightEvents,
  });

}