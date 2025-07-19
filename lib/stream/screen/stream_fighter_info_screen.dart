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
          color: MY_DARK_GREY_COLOR,
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
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        _renderName(name: f1.name, borderColor: Color(0xFF198CFF)),
                        f1.nickname != null ?
                        Text(f1.nickname!,style: defaultTextStyle,) : SizedBox(height: defaultTextStyle.fontSize ?? 14),
                      ],
                    ),
                    Column(
                      children: [
                        _renderName(name: f2.name, borderColor: Color(0xFFE3233C)),
                        f2.nickname != null ?
                        Text(f2.nickname!,style: defaultTextStyle,) : SizedBox(height: defaultTextStyle.fontSize ?? 14),
                      ],
                    )
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
                f1Info: f1.weight,
                f2Info: f2.weight,
                context: context,
              ),
              _renderBoxWithFightersInfo(
                context: context,
                label: '리치',
                f1Info: '${f1.reach}cm',
                f2Info: '${f2.reach}cm',
              ),
              _renderBoxWithFightersInfo(
                label: '역대 전적',
                f1Info: _renderRecord(f1.record),
                f2Info: _renderRecord(f2.record),
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
    final halfWidth = MediaQuery.of(context).size.width / 2;
    return Stack(
      children: [
        // 배경: 전체 검정
        Container(color: Colors.black, height: 48),
        // 왼쪽 반쪽 테두리 박스 (파란색)
        Positioned.fill(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: halfWidth,
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: Color(0xFF198CFF), width: 2),
                  top: BorderSide(color: Color(0xFF198CFF), width: 2),
                  bottom: BorderSide(color: Color(0xFF198CFF), width: 2),
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
            ),
          ),
        ),
        // 오른쪽 반쪽 테두리 박스 (빨간색)
        Positioned.fill(
          child: Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: halfWidth,
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(color: Color(0xFFE3233C), width: 2),
                  top: BorderSide(color: Color(0xFFE3233C), width: 2),
                  bottom: BorderSide(color: Color(0xFFE3233C), width: 2),
                ),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
            ),
          ),
        ),
        // 내용
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(f1Info, style: TextStyle(color: Colors.white)),
              Text(label, style: TextStyle(color: Colors.grey)),
              Text(f2Info, style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ],
    );
  }

  _renderName({required String name, required Color borderColor}) {
    return Container(
      padding: EdgeInsets.only(top: 4.0,bottom: 4.0,left: 8.0,right: 8.0),
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
