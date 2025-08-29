import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    return SingleChildScrollView(
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
                padding: EdgeInsets.symmetric(vertical: 34.h),
                child: Text(
                  '선수 프로필',
                  style: defaultTextStyle.copyWith(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      _renderName(name: f1.name, borderColor: RED_COLOR),
                      f1.nickname != null
                          ? Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            child: Text(
                              f1.nickname!,
                              style: defaultTextStyle,
                            ),
                          )
                          : SizedBox(height: 24.h),
                    ],
                  ),
                  Column(
                    children: [
                      _renderName(name: f2.name, borderColor: BLUE_COLOR),
                      f2.nickname != null
                          ? Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            child: Text(
                              f2.nickname!,
                              style: defaultTextStyle,
                            ),
                          )
                          : SizedBox(height: 38.h),
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
              f1Info: '${f1.weight.toString()}kg',
              f2Info: '${f2.weight.toString()}kg',
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
              f1Info: _renderRecord(f1.record),
              f2Info: _renderRecord(f2.record),
              context: context,
            ),
          ],
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
      padding: EdgeInsets.only(bottom: 30.h),
      child: SizedBox(
        height: 22.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 100.w,
              child: Text(
                f1Info,
                style: defaultTextStyle.copyWith(fontSize: 14.sp),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(width: 20.w),
            SizedBox(
              width: 94.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(color: RED_COLOR, width: 2.w, height: 17.h),
                  Text(
                    label,
                    style: defaultTextStyle.copyWith(
                      fontSize: 14.sp,
                      color: Colors.grey,
                    ),
                  ),
                  Container(color: BLUE_COLOR, width: 2.w, height: 17.h),
                ],
              ),
            ),
            SizedBox(width: 20.w),
            SizedBox(
              width: 100.w,
              child: Text(
                f2Info,
                style: defaultTextStyle.copyWith(fontSize: 14.sp),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _renderName({required String name, required Color borderColor}) {
    return Container(
      constraints: BoxConstraints(minHeight: 23.h),
      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 10.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: borderColor, width: 2.w),
        color: Colors.black,
      ),
      child: Text(
        name,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: Colors.white,
          overflow: TextOverflow.ellipsis,
          fontSize: 15.sp,
        ),
        textAlign: TextAlign.center,
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
