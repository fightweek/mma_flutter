import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mma_flutter/common/model/base_state_model.dart';
import 'package:mma_flutter/fight_event/model/fight_event_model.dart';
import 'package:mma_flutter/fight_event/provider/fight_event_provider.dart';
import 'package:mma_flutter/fight_event/repository/fight_event_repository.dart';
import 'package:mma_flutter/fighter/model/fighter_model.dart';
import 'package:mma_flutter/fighter/provider/fighter_provider.dart';
import 'package:mma_flutter/fighter/repository/fighter_repository.dart';
import 'package:mocktail/mocktail.dart';

import '../../fixture/fightevent/upcoming/upcoming_fight_event_fixture.dart';

class _MockFightEventRepo extends Mock implements FightEventRepository {}

class _MockFighterRepo extends Mock implements FighterRepository {}

/**
 * 1. state[date] 상태 없는 경우, getSchedule() 호출 이후 state[date] 상태 초기화 여부 확인
 * (+ 해당 이벤트의 ffeList에 존재하는 fighter 상태 업데이트 여부 확인),
 * (+ upcoming event인 경우, alertProvider의 상태 변화 여부 확인)
 * (+ state[date] 이미 있는 경우, getSchedule() 호출 시 repo 호출 여부 확인 (행위 기반))
 * 2. forceRefetch=true인 경우, 이미 state[date] 있어도 repo 호출되어야 함
 * 3. 입력받은 날짜에 해당하는 이벤트가 없는 경우, state의 data null 여부 확인
 * 4. Exception 발생 시 state[date] StateError 여부 확인
 */

String _stringDate(DateTime date) {
  return DateFormat('yyyy-MM-dd').format(date);
}

void main() {
  late _MockFightEventRepo mockFightEventRepo;
  late ProviderContainer container;
  late ScheduleStateNotifier notifier;
  FightEventModel upcomingFightEventModel = FightEventModel.fromJson(
    upcomingFightEventJson,
  );
  DateTime dateTimeToFetch = DateTime(2000, 10, 10);
  String key = _stringDate(dateTimeToFetch);

  setUp(() {
    mockFightEventRepo = _MockFightEventRepo();
    final mockFighterRepo = _MockFighterRepo();
    container = ProviderContainer(
      overrides: [
        fightEventRepositoryProvider.overrideWithValue(mockFightEventRepo),
        fighterRepositoryProvider.overrideWithValue(mockFighterRepo),
      ],
    );
    notifier = container.read(fightEventProvider.notifier);
  });

  test('FightEventProvider getSchedule() test', () async {
    // given
    when(
      () => mockFightEventRepo.getSchedule(date: key),
    ).thenAnswer((invocation) async => upcomingFightEventModel);

    // when
    /// call notifier's getSchedule() method more than once to verify whether
    /// caching logic is applied correctly
    /// (do not request to server if fight-event's state already exists)
    await notifier.getSchedule(date: dateTimeToFetch);
    await notifier.getSchedule(date: dateTimeToFetch);

    // then
    expect(
      container.read(fightEventProvider)[key],
      isA<StateData<FightEventModel>>(),
    );
    for (FighterFightEventModel ffe
        in upcomingFightEventModel.fighterFightEvents) {
      expect(
        container.read(fighterProvider)[ffe.winner.id],
        isA<StateData<FighterModel>>(),
      );
      expect(
        container.read(fighterProvider)[ffe.loser.id],
        isA<StateData<FighterModel>>(),
      );
    }
    verify(() => mockFightEventRepo.getSchedule(date: key)).called(1);
  });

  test('FightEventProvider getSchedule(forceRefetch=true) test', () async {
    // given
    when(
      () => mockFightEventRepo.getSchedule(date: key),
    ).thenAnswer((invocation) async => upcomingFightEventModel);

    // when
    await notifier.getSchedule(date: dateTimeToFetch);
    await notifier.getSchedule(date: dateTimeToFetch, forceRefetch: true);

    // then
    expect(
      container.read(fightEventProvider)[key],
      isA<StateData<FightEventModel>>(),
    );
    verify(() => mockFightEventRepo.getSchedule(date: key)).called(2);
  });

  test('FightEventProvider getSchedule() event null case test', () async {
    // given
    when(
      () => mockFightEventRepo.getSchedule(date: key),
    ).thenAnswer((invocation) async => null);

    // when
    await notifier.getSchedule(date: dateTimeToFetch);

    // then
    expect(
      (container.read(fightEventProvider)[key] as StateData<FightEventModel>)
          .data,
      null,
    );
  });

  test('FightEventProvider getSchedule() test [Exception case]', () async {
    // given
    when(
      () => mockFightEventRepo.getSchedule(date: key),
    ).thenThrow(Exception('error'));

    // when && then
    await notifier.getSchedule(date: dateTimeToFetch);

    // then
    expect(container.read(fightEventProvider)[key], isA<StateError>());
  });
}
