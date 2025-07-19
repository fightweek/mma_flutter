import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mma_flutter/common/model/base_state_model.dart';
import 'package:mma_flutter/fight_event/model/fight_event_model.dart';
import 'package:mma_flutter/fight_event/repository/fight_event_repository.dart';
import 'package:mma_flutter/fighter/provider/fighter_provider.dart';

final fightEventProvider = StateNotifierProvider<
  ScheduleStateNotifier,
  Map<String, StateBase<FightEventModel>>
>((ref) {
  final scheduleRepository = ref.read(scheduleRepositoryProvider);
  return ScheduleStateNotifier(
    ref: ref,
    scheduleRepository: scheduleRepository,
  );
});

class ScheduleStateNotifier
    extends StateNotifier<Map<String, StateBase<FightEventModel>>> {
  final ScheduleRepository scheduleRepository;
  final Ref ref;

  ScheduleStateNotifier({required this.ref, required this.scheduleRepository})
    : super({DateFormat('yyyy-MM-dd').format(DateTime.now()): StateLoading()}) {
    print('ScheduleStateNotifier 생성됨');
    getSchedule(date: DateTime.now());
  }

  Future<void> getSchedule({required DateTime date, bool? isRefresh}) async {
    try {
      final key = _stringDate(date);
      print(state[key]);
      /** 1. refresh true -> 무조건 재요청
       * 2. 혹은 해당 날짜에 데이터 로딩 아직 안 된 경우, 요청
       */
      if (isRefresh != null || state[key] is! StateData) {
        print('get schedule');
        state = {...state, key: StateLoading()};
        final resp = await scheduleRepository.getSchedule(date: key);
        state = {...state, key: StateData(data: resp)};
        if (resp != null) {
          resp.fighterFightEvents.forEach((e) {
            ref.read(fighterProvider.notifier).updateFighter(e.winner);
            ref.read(fighterProvider.notifier).updateFighter(e.loser);
          });
        }
      } else {
        // 이미 데이터가 있음과 동시에 refresh 하는 것도 아닌 경우, 그대로 빠져나감
        return;
      }
    } on DioException catch (e) {
      state = {...state, _stringDate(date): StateError(message: '스케줄 못 불러옴')};
      print(e.error);
    } catch (e, stack) {
      print('예외 발생: $e');
      print('스택: $stack');
      state = {...state, _stringDate(date): StateError(message: '스케줄 못 불러옴')};
    }
  }

  String _stringDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }
}
