import 'package:flutter_test/flutter_test.dart';
import 'package:mma_flutter/fighter/model/fighter_model.dart';

import '../../fixture/fighter/fighter_model_json_fixture.dart';

void expectFighterModel({
  required FighterModel model,
  required Map<String, dynamic> expectedJson,
  required bool isDetail,
}) {
  expect(model.id, equals(expectedJson['id']));
  expect(model.name, equals(expectedJson['name']));
  expect(model.nickname, equals(expectedJson['nickname']));
  expect(model.ranking, equals(expectedJson['ranking']));
  expect(model.record.win, equals(expectedJson['record']['win']));
  expect(model.record.draw, equals(expectedJson['record']['draw']));
  expect(model.record.loss, equals(expectedJson['record']['loss']));
  expect(
    model.headshotUrl,
    isDetail ? isNull : equals(expectedJson['headshotUrl']),
  );
}

void main() {
  test('FighterModel fromJson parsing test', () {
    // given
    final idNullJson = {...fighterModelJson}..remove('id');
    final nameNullJson = {...fighterModelJson}..remove('name');
    final nicknameNullJson = {...fighterModelJson}..remove('nickname');
    final rankingNullJson = {...fighterModelJson}..remove('ranking');
    final recordNullJson = {...fighterModelJson}..remove('record');
    final headshotUrlNullJson = {...fighterModelJson}..remove('headshotUrl');

    // when
    /// those models do not occur error while parsing json
    final fighterModel = FighterModel.fromJson(fighterModelJson);
    final nicknameNullModel = FighterModel.fromJson(nicknameNullJson);
    final rankingNullModel = FighterModel.fromJson(rankingNullJson);
    final headshotUrlNullModel = FighterModel.fromJson(headshotUrlNullJson);

    // then
    expectFighterModel(
      model: fighterModel,
      expectedJson: fighterModelJson,
      isDetail: false,
    );

    expect(nicknameNullModel.nickname, isNull);
    expect(rankingNullModel.ranking, isNull);
    expect(headshotUrlNullModel.headshotUrl, isNull);

    expect(() => FighterModel.fromJson(idNullJson), throwsA(isA<TypeError>()));
    expect(
      () => FighterModel.fromJson(nameNullJson),
      throwsA(isA<TypeError>()),
    );
    expect(
      () => FighterModel.fromJson(recordNullJson),
      throwsA(isA<TypeError>()),
    );
  });
}
