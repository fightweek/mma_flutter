import 'package:flutter_test/flutter_test.dart';
import 'package:mma_flutter/fight_event/model/fight_event_model.dart';

import '../../fixture/fightevent/completed_fight_event_json_fixture.dart';

void expectCompletedFightEventModel(
  FightEventModel model,
  Map<String, dynamic> json,
) {
  expect(model.id, equals(json['id']));
  expect(model.name, equals(json['name']));
  expect(model.date, equals(DateTime.parse(json['date'] as String)));
  expect(model.mainCardDateTimeInfo, isNull);
  expect(model.prelimCardDateTimeInfo, isNull);
  expect(model.earlyCardDateTimeInfo, isNull);
  expect(model.mainCardCnt, isNull);
  expect(model.prelimCardCnt, isNull);
  expect(model.earlyCardCnt, isNull);
  expect(model.location, json['location']);
  expect(
    model.fighterFightEvents.length,
    (json['fighterFightEvents'] as List).length,
  );
  expect(model.upcoming, json['upcoming']);
  expect(model.alert, json['alert']);
}

Map<String, dynamic> removeKey(final Map<String, dynamic> json, String key) {
  /// 원본 손상 방지
  final newJson = {...json};
  return newJson..remove(key);
}

void main() {
  test('FightEventModel fromJson parsing test', () {
    // given
    final requiredKeys = {
      'id',
      'name',
      'date',
      'location',
      'fighterFightEvents',
      'upcoming',
      'alert',
    };
    final Map<String, dynamic Function(FightEventModel)> nullCases = {
      'mainCardDateTimeInfo': (e) => e.mainCardDateTimeInfo,
      'prelimCardDateTimeInfo': (e) => e.prelimCardDateTimeInfo,
      'earlyCardDateTimeInfo': (e) => e.earlyCardDateTimeInfo,
      'mainCardCnt': (e) => e.mainCardCnt,
      'prelimCardCnt': (e) => e.prelimCardCnt,
      'earlyCardCnt': (e) => e.earlyCardCnt,
    };

    //when
    final completedFightEventModel = FightEventModel.fromJson(
      completedFightEventModelJson,
    );

    // (when &) then
    /// valid case
    nullCases.forEach((key, extractor) {
      final model = FightEventModel.fromJson(
        removeKey(completedFightEventModelJson, key),
      );
      expect(extractor(model), isNull);
    });
    expectCompletedFightEventModel(
      completedFightEventModel,
      completedFightEventModelJson,
    );

    /// exception case
    for (final key in requiredKeys) {
      expect(
        () => FightEventModel.fromJson(
          removeKey(completedFightEventModelJson, key),
        ),
        throwsA(isA<TypeError>()),
        reason: 'Should throw when "$key" missing',
      );
    }
  });
}
