import 'package:flutter_test/flutter_test.dart';
import 'package:mma_flutter/fighter/model/fighter_detail_model.dart';

import 'fighter_model_test.dart';

void main() {
  test('FighterDetailModel fromJson parsing test', () {
    // given
    final fighterDetailModelJson = {
      "id": 1,
      "name": "Diego Lopes",
      "nickname": null,
      "ranking": 2,
      "record": {"win": 27, "draw": 0, "loss": 7},
      "headshotUrl": null,
      "height": 180,
      "weight": 65.8,
      "birthday": "1994-12-30",
      "reach": 183,
      "nation": null,
      "alert": false,
      "bodyUrl": "https://my-ufc-fighter-img-bucket.s3.ap-northeast-2..",
      "fighterFightEvents": [
        {
          "eventName": "UFC Fight Night: Lopes vs Silva",
          "id": 1,
          "fightWeight": "Featherweight",
          "winner": {
            "id": 1,
            "name": "Diego Lopes",
            "nickname": null,
            "ranking": 2,
            "record": {"win": 27, "draw": 0, "loss": 7},
            "headshotUrl": "123123",
          },
          "loser": {
            "id": 2,
            "name": "Jean Silva",
            "nickname": "Lord",
            "ranking": 11,
            "record": {"win": 16, "draw": 0, "loss": 3},
            "headshotUrl": "123123",
          },
          "result": {
            "winMethod": "KO_TKO",
            "round": 2,
            "endTime": "00:04:48",
            "description": "Punches",
            "draw": false,
            "nc": false,
          },
          "title": false,
          "eventId": 1,
          "eventDate": "2025-09-13",
        },
        {
          "eventName": "UFC 314: Volkanovski vs Lopes",
          "id": 221,
          "fightWeight": "Featherweight",
          "winner": {
            "id": 407,
            "name": "Alexander Volkanovski",
            "nickname": "The Great",
            "ranking": 0,
            "record": {"win": 27, "draw": 0, "loss": 4},
            "headshotUrl": "123123",
          },
          "loser": {
            "id": 1,
            "name": "Diego Lopes",
            "nickname": null,
            "ranking": 2,
            "record": {"win": 27, "draw": 0, "loss": 7},
            "headshotUrl": "123123",
          },
          "result": {
            "winMethod": "U_DEC",
            "round": 5,
            "endTime": "00:05",
            "description": null,
            "draw": false,
            "nc": false,
          },
          "title": true,
          "eventId": 19,
          "eventDate": "2025-04-12",
        },
      ],
    };

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
