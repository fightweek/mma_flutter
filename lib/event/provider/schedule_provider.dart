import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:mma_flutter/common/model/async_state.dart';
import 'package:mma_flutter/event/model/schedule_model.dart';
import 'package:mma_flutter/event/repository/schedule_repository.dart';

final scheduleProvider = StateNotifierProvider<
  ScheduleStateNotifier,
  Map<String, StateBase<FightEventModel>>
>((ref) {
  final scheduleRepository = ref.read(scheduleRepositoryProvider);
  return ScheduleStateNotifier(scheduleRepository: scheduleRepository);
});

class ScheduleStateNotifier
    extends StateNotifier<Map<String, StateBase<FightEventModel>>> {
  final ScheduleRepository scheduleRepository;

  ScheduleStateNotifier({required this.scheduleRepository})
    : super({'${DateTime.now()}': StateLoading()}) {
    print('🟢 ScheduleStateNotifier 생성됨');
    getSchedule(date: DateTime.now());
  }

  Future<void> getSchedule({required DateTime date, bool? isRefresh}) async {
    print('get schedule');
    try {
      final key = _stringDate(date);
      /** 1. refresh true -> 무조건 재요청
       * 2. 혹은 해당 날짜에 데이터 로딩 아직 안 된 경우, 요청
       */
      if (isRefresh != null || state[key] is! StateData) {
        state = {...state, key: StateLoading()};
        final resp = await scheduleRepository.getSchedule(date: key);
        print(resp);
        state = {...state, key: StateData(data: resp)};
        print(state[key].runtimeType);
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
      state['$date'] = StateError(message: '스케줄 가져오기 실패');
    }
  }

  String _stringDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }
}
