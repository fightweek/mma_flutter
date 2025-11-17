import 'package:flutter_test/flutter_test.dart';
import 'package:mma_flutter/fight_event/model/fight_event_model.dart';

import '../../fighter/model/fighter_model_test.dart';
import '../../fixture/fightevent/completed/completed_fighter_fight_event_fixture.dart';
import '../../fixture/fightevent/upcoming/upcoming_fighter_fight_event_fixture.dart';

const winMethodJsonMap = {
  WinMethod.sub: 'SUB',
  WinMethod.koTko: 'KO_TKO',
  WinMethod.uDec: 'U_DEC',
  WinMethod.mDec: 'M_DEC',
  WinMethod.sDec: 'S_DEC',
};

void expectFightResult(FightResultModel model, Map<String, dynamic> json) {
  if (model.winMethod != null) {
    expect(winMethodJsonMap[model.winMethod], equals(json['winMethod']));
  }
  expect(model.round, equals(json['round']));
  expect(model.endTime, equals(parseEndTime(json['endTime'])));
  expect(model.description, equals(json['description']));
  expect(model.nc, equals(json['nc']));
  expect(model.draw, equals(json['draw']));
}

void expectFighterFightEventModel({
  required FighterFightEventModel model,
  required Map<String, dynamic> json,
  required bool isCompleted,
}) {
  expect(model.id, equals(json['id']));
  expect(model.eventName, equals(json['eventName']));
  expect(model.fightWeight, equals(json['fightWeight']));
  expectFighterModel(
    model: model.winner,
    expectedJson: json['winner'],
    isDetail: false,
  );
  expectFighterModel(
    model: model.loser,
    expectedJson: json['loser'],
    isDetail: false,
  );
  if (isCompleted) {
    expectFightResult(model.result!, json['result']);
  }
  expect(model.title, equals(json['title']));
  expect(model.eventId, equals(json['eventId']));
  expect(model.eventDate, equals(DateTime.parse(json['eventDate'] as String)));
}

/** This test checks not only FighterFightEventModel itself,
 * but also ensures that:
 *   - 'winner' and 'loser' JSON objects are parsed into FighterModel correctly,
 *   - FightResultModel is parsed for completed events,
 * effectively validating the entire nested structure of a FighterFightEventModel.
 */
void main() {
  test('FighterFightEventModel fromJson parsing test', () {
    // given

    // when
    final completedFighterFightEventModel = FighterFightEventModel.fromJson(
      completedFighterFightEventJson,
    );
    final upcomingFighterFightEventModel = FighterFightEventModel.fromJson(
      upcomingFighterFightEventJson,
    );

    // then
    expectFighterFightEventModel(
      model: completedFighterFightEventModel,
      json: completedFighterFightEventJson,
      isCompleted: true,
    );
    expectFighterFightEventModel(
      model: upcomingFighterFightEventModel,
      json: upcomingFighterFightEventJson,
      isCompleted: false,
    );
  });
}
