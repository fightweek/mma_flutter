import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/common/const/style.dart';

class CustomAlertDialog extends StatelessWidget {
  final String? titleMsg;
  final String contentMsg;
  final List<Widget>? actions;

  const CustomAlertDialog({
    this.titleMsg,
    required this.contentMsg,
    this.actions,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      backgroundColor: DARK_GREY_COLOR,
      titlePadding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 16.h),
      contentPadding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 12.h),
      actionsPadding: EdgeInsets.only(bottom: 8.h, right: 8.w),
      title:
          titleMsg != null
              ? Text(
                titleMsg!,
                style: defaultTextStyle.copyWith(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w600,
                ),
              )
              : null,
      content: Text(
        contentMsg,
        style: defaultTextStyle.copyWith(fontSize: 12.sp),
      ),
      actions:
          actions ??
          [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                fixedSize: Size(40.w, 24.h),
                backgroundColor: DARK_GREY_COLOR,
              ),
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                '닫기',
                style: defaultTextStyle.copyWith(fontSize: 12.sp),
              ),
            ),
          ],
    );
  }
}
