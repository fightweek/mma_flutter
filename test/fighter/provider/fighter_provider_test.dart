import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mma_flutter/common/model/base_state_model.dart';
import 'package:mma_flutter/fight_event/model/fight_event_model.dart';
import 'package:mma_flutter/fighter/model/fighter_detail_model.dart';
import 'package:mma_flutter/fighter/model/fighter_model.dart';
import 'package:mma_flutter/fighter/model/update_preference_model.dart';
import 'package:mma_flutter/fighter/provider/fighter_provider.dart';
import 'package:mma_flutter/fighter/repository/fighter_repository.dart';
import 'package:mocktail/mocktail.dart';

import '../../fixture/fighter/fighter_detail_model_json_fixture.dart';

class _MockFighterRepo extends Mock implements FighterRepository {}

void main() {
  late _MockFighterRepo mockFighterRepo;
  late ProviderContainer container;
  late FighterStateNotifier notifier;
  late FighterDetailModel fighterDetailModel;

  setUp(() {
    mockFighterRepo = _MockFighterRepo();
    container = ProviderContainer(
      overrides: [fighterRepositoryProvider.overrideWithValue(mockFighterRepo)],
    );
    notifier = container.read(fighterProvider.notifier);
    fighterDetailModel = FighterDetailModel.fromJson(fighterDetailModelJson);
  });

  test('FighterProvider detail() test [successful case]', () async {
    // given
    final fighterId = fighterDetailModel.id;

    when(() => mockFighterRepo.detail(fighterId: fighterId)).thenAnswer(
      (invocation) async => fighterDetailModel,
    );

    // when
    /// call notifier's detail() method more than once to verify whether
    /// caching logic is applied correctly
    /// (do not request to server if fighter's state already exists)
    await notifier.detail(id: fighterId);
    await notifier.detail(id: fighterId);

    // then
    expect(
      container.read(fighterProvider)[fighterId],
      isA<StateData<FighterDetailModel>>(),
    );
    verify(() => mockFighterRepo.detail(fighterId: fighterId)).called(1);

    /// Also needs to make sure that each opponent's state is StateData<FighterModel>
    for (FighterFightEventModel ffe in fighterDetailModel.fighterFightEvents!) {
      final opponentModel =
          ffe.winner.name == fighterDetailModel.name ? ffe.loser : ffe.winner;
      expect(
        container.read(fighterProvider)[opponentModel.id],
        isA<StateData<FighterModel>>(),
      );
    }
  });

  test('FighterProvider detail(forceRefetch=true) test', () async {
    // given
    final fighterId = fighterDetailModel.id;
    when(
          () => mockFighterRepo.detail(fighterId: fighterId),
    ).thenAnswer((invocation) async => fighterDetailModel);

    // when
    await notifier.detail(id: fighterId);
    await notifier.detail(id: fighterId, forceRefetch: true);

    // then
    expect(
      container.read(fighterProvider)[fighterId],
      isA<StateData<FighterDetailModel>>(),
    );
    verify(() => mockFighterRepo.detail(fighterId: fighterId)).called(2);
  });

  test('FighterProvider detail() test [Exception case]', () async {
    // given
    final fighterId = fighterDetailModel.id;

    when(
      () => mockFighterRepo.detail(fighterId: fighterId),
    ).thenThrow(Exception('error'));

    // when && then
    await notifier.detail(id: fighterId);

    // then
    expect(
      container.read(fighterProvider)[fighterDetailModel.id],
      isA<StateError>(),
    );
  });

  test('FighterProvider updatePreference() test', () async {
    // given
    final prevAlert = fighterDetailModel.alert;
    final updatePreferenceModel = UpdatePreferenceModel(
      targetId: fighterDetailModel.id,
      on: !prevAlert,
    );
    when(() => mockFighterRepo.detail(fighterId: 1)).thenAnswer(
      (invocation) async => FighterDetailModel.fromJson(fighterDetailModelJson),
    );
    when(
      () => mockFighterRepo.updatePreference(request: updatePreferenceModel),
    ).thenAnswer((invocation) async {});

    // when
    await notifier.detail(id: fighterDetailModel.id);
    notifier.updatePreference(model: updatePreferenceModel, alert: !prevAlert);

    // then
    expect(
      (container.read(fighterProvider)[fighterDetailModel.id]
              as StateData<FighterDetailModel>)
          .data!
          .alert,
      equals(!prevAlert),
    );
  });
}
