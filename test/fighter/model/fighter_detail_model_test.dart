import 'package:flutter_test/flutter_test.dart';
import 'package:mma_flutter/fighter/model/fighter_detail_model.dart';

import '../../fixture/fighter/fighter_detail_model_json_fixture.dart';
import 'fighter_model_test.dart';

void main() {
  test('FighterDetailModel fromJson parsing test', () {

    // given
    final heightNullJson = {...fighterDetailModelJson}..remove('height');
    final weightNullJson = {...fighterDetailModelJson}..remove('weight');
    final birthdayNullJson = {...fighterDetailModelJson}..remove('birthday');
    final reachNullJson = {...fighterDetailModelJson}..remove('reach');
    final alertNullJson = {...fighterDetailModelJson}..remove('alert');
    final bodyUrlNullJson = {...fighterDetailModelJson}..remove('bodyUrl');
    final fighterFightEventsNullJson = {...fighterDetailModelJson}
      ..remove('fighterFightEvents');

    // when
    /// those models do not occur error while parsing json
    final fighterDetailModel = FighterDetailModel.fromJson(
      fighterDetailModelJson,
    );
    final weightNullModel = FighterDetailModel.fromJson(weightNullJson);
    final birthdayNullModel = FighterDetailModel.fromJson(birthdayNullJson);
    final reachNullModel = FighterDetailModel.fromJson(reachNullJson);
    final fighterFightEventsNullModel = FighterDetailModel.fromJson(
      fighterFightEventsNullJson,
    );

    // then
    expectFighterModel(
      model: fighterDetailModel,
      expectedJson: fighterDetailModelJson,
      isDetail: true,
    );
    expect(fighterDetailModel.fighterFightEvents!.length, equals(2));
    expect(weightNullModel.weight, isNull);
    expect(birthdayNullModel.birthday, isNull);
    expect(reachNullModel.reach, isNull);
    expect(fighterFightEventsNullModel.fighterFightEvents, isNull);

    expect(
      () => FighterDetailModel.fromJson(heightNullJson),
      throwsA(isA<TypeError>()),
    );
    expect(
      () => FighterDetailModel.fromJson(alertNullJson),
      throwsA(isA<TypeError>()),
    );
    expect(
      () => FighterDetailModel.fromJson(bodyUrlNullJson),
      throwsA(isA<TypeError>()),
    );
  });
}
