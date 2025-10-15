import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/common/const/style.dart';

class FightEventDatePicker extends StatelessWidget {
  final DateTime focusedDay;
  final ValueChanged<DateTime> onDateTimeChanged;
  final VoidCallback datePickerButtonPressed;

  const FightEventDatePicker({
    required this.focusedDay,
    required this.onDateTimeChanged,
    required this.datePickerButtonPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 300.h,
        color: DARK_GREY_COLOR,
        child: Column(
          children: [
            SizedBox(
              height: 250,
              child: CupertinoTheme(
                data: CupertinoThemeData(
                  textTheme: CupertinoTextThemeData(
                    textStyle: defaultTextStyle,
                  ),
                ),
                child: CupertinoDatePicker(
                  backgroundColor: DARK_GREY_COLOR,
                  dateOrder: DatePickerDateOrder.ymd,
                  mode: CupertinoDatePickerMode.monthYear,
                  initialDateTime: focusedDay,
                  minimumDate: DateTime(1950),
                  maximumDate: DateTime(DateTime.now().year + 1),
                  onDateTimeChanged: onDateTimeChanged,
                ),
              ),
            ),
            SizedBox(
              height: 31.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(135.w, 31.h),
                      backgroundColor: Color(0xff8c8c8c),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text('닫기', style: defaultTextStyle),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: ElevatedButton(
                      onPressed: datePickerButtonPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: BLUE_COLOR,
                        fixedSize: Size(135.w, 31.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text('확인', style: defaultTextStyle),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
