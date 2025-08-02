import 'package:flutter/material.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/common/const/style.dart';
import 'package:mma_flutter/fight_event/model/fight_event_model.dart';
import 'package:mma_flutter/stream/model/stream_fight_event_model.dart';

class FighterInfoScreen extends StatelessWidget {
  final StreamFighterModel f1;
  final StreamFighterModel f2;

  const FighterInfoScreen({required this.f1, required this.f2, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Container(
          color: DARK_GREY_COLOR,
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Column(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    '선수 프로필',
                    style: defaultTextStyle.copyWith(fontSize: 20.0),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        _renderName(
                          name: f1.name,
                          borderColor: BLUE_COLOR,
                        ),
                        f1.nickname != null
                            ? Text(f1.nickname!, style: defaultTextStyle)
                            : SizedBox(height: defaultTextStyle.fontSize ?? 14),
                      ],
                    ),
                    Column(
                      children: [
                        _renderName(
                          name: f2.name,
                          borderColor: RED_COLOR,
                        ),
                        f2.nickname != null
                            ? Text(f2.nickname!, style: defaultTextStyle)
                            : SizedBox(height: defaultTextStyle.fontSize ?? 14),
                      ],
                    ),
                  ],
                ),
              ),
              _renderBoxWithFightersInfo(
                label: '랭킹',
                f1Info: f1.ranking != null ? f1.ranking.toString() : '-',
                f2Info: f2.ranking != null ? f2.ranking.toString() : '-',
                context: context,
              ),
              _renderBoxWithFightersInfo(
                label: '나이',
                f1Info: _calculateAge(f1.birthday).toString(),
                f2Info: _calculateAge(f2.birthday).toString(),
                context: context,
              ),
              _renderBoxWithFightersInfo(
                label: '신장',
                f1Info: '${f1.height}cm',
                f2Info: '${f2.height}cm',
                context: context,
              ),
              _renderBoxWithFightersInfo(
                label: '무게',
                f1Info: f1.weight.toString(),
                f2Info: f2.weight.toString(),
                context: context,
              ),
              _renderBoxWithFightersInfo(
                context: context,
                label: '리치',
                f1Info: '${f1.reach}cm',
                f2Info: '${f2.reach}cm',
              ),
              _renderBoxWithFightersInfo(
                label: '전적',
                f1Info: _renderRecord(f1.fightRecord),
                f2Info: _renderRecord(f2.fightRecord),
                context: context,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _renderBoxWithFightersInfo({
    required String label,
    required String f1Info,
    required String f2Info,
    required BuildContext context,
  }) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            f1Info,
            style: defaultTextStyle.copyWith(fontSize: 16.0),
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(
            width: 110.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  color: BLUE_COLOR,
                  child: SizedBox(width: 4.0, height: 14.0),
                ),
                Text(label, style: defaultTextStyle.copyWith(fontSize: 16.0,color: Colors.grey)),
                Container(
                  color: RED_COLOR,
                  child: SizedBox(width: 4.0, height: 14.0),
                ),
              ],
            ),
          ),
          Text(f2Info, style: defaultTextStyle.copyWith(fontSize: 16.0)),
        ],
      ),
    );
  }

  _renderName({required String name, required Color borderColor}) {
    return Container(
      padding: EdgeInsets.only(top: 4.0, bottom: 4.0, left: 8.0, right: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: borderColor, width: 3.0),
        color: Colors.black,
      ),
      child: Text(
        name,
        style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
      ),
    );
  }

  int _calculateAge(DateTime birthday) {
    DateTime now = DateTime.now();
    int age = now.year - birthday.year;
    if (birthday.month < now.month ||
        (birthday.month == now.month && birthday.day < now.day)) {
      age--;
    }
    return age;
  }

  String _renderRecord(FightRecordModel record) {
    return '${record.win}승 ${record.loss}패 ${record.draw}무';
  }
}
