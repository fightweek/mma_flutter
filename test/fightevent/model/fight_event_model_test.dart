import 'package:flutter_test/flutter_test.dart';
import 'package:mma_flutter/fight_event/model/fight_event_model.dart';

import '../../fixture/fightevent/completed/completed_fight_event_fixture.dart';
import '../../fixture/fightevent/upcoming/upcoming_fight_event_fixture.dart';
import 'fighter_fight_event_model_test.dart';

void expectFightEventModel({
  required FightEventModel model,
  required Map<String, dynamic> json,
  required bool isCompleted,
}) {
  expect(model.id, equals(json['id']));
  expect(model.name, equals(json['name']));
  expect(model.date, equals(DateTime.parse(json['date'] as String)));
  if (isCompleted) {
    expect(model.mainCardDateTimeInfo, isNull);
    expect(model.prelimCardDateTimeInfo, isNull);
    expect(model.earlyCardDateTimeInfo, isNull);
    expect(model.mainCardCnt, isNull);
    expect(model.prelimCardCnt, isNull);
    expect(model.earlyCardCnt, isNull);
  } else {
    /// 프로덕션 환경에선 upcoming event의 cardInfo nullable (ufc stats(crawling server)에 의존함)
    expect(model.mainCardDateTimeInfo, isNotNull);
    expect(model.mainCardCnt, isNotNull);
  }
  expect(model.location, json['location']);
  expect(
    model.fighterFightEvents.length,
    (json['fighterFightEvents'] as List).length,
  );
  expect(model.upcoming, isCompleted ? false : true);
  expect(model.alert, json['alert']);
}

Map<String, dynamic> removeKey(final Map<String, dynamic> json, String key) {
  /// 원본 손상 방지
  final newJson = {...json};
  return newJson..remove(key);
}

/** This test checks not only FightEventModel itself,
 * but also ensures that:
 *   - 'fighterFightEvents' JSON object is parsed into List<FighterFightEventModel> correctly,
 * effectively validating the entire nested structure of a FightEventModel.
 */
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
      completedFightEventJson,
    );
    final upcomingFightEventModel = FightEventModel.fromJson(
      upcomingFightEventJson,
    );

    // (when &) then
    /// valid case
    nullCases.forEach((key, extractor) {
      final model = FightEventModel.fromJson(
        removeKey(completedFightEventJson, key),
      );
      expect(extractor(model), isNull);
    });
    expectFightEventModel(
      model: completedFightEventModel,
      json: completedFightEventJson,
      isCompleted: true,
    );
    expectFightEventModel(
      model: upcomingFightEventModel,
      json: upcomingFightEventJson,
      isCompleted: false,
    );
    for (dynamic json
        in (completedFightEventJson['fighterFightEvents'] as List<dynamic>)) {
      final ffeModel = FighterFightEventModel.fromJson(json);
      expectFighterFightEventModel(
        model: ffeModel,
        json: json,
        isCompleted: true,
      );
    }
    for (dynamic json
        in (upcomingFightEventJson['fighterFightEvents'] as List<dynamic>)) {
      final ffeModel = FighterFightEventModel.fromJson(json);
      expectFighterFightEventModel(
        model: ffeModel,
        json: json,
        isCompleted: false,
      );
    }

    /// exception case
    for (final key in requiredKeys) {
      expect(
        () => FightEventModel.fromJson(removeKey(completedFightEventJson, key)),
        throwsA(isA<TypeError>()),
        reason: 'Should throw when "$key" missing',
      );
    }
  });
}
