import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mma_flutter/common/component/point_with_icon.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/common/const/style.dart';

class BetPointBox extends StatelessWidget {
  final int point;
  final bool isSeedPoint;
  final Color? borderColor;
  final Color? backGroundColor;

  const BetPointBox({
    required this.point,
    required this.isSeedPoint,
    this.borderColor,
    this.backGroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 21.h),
      child: Column(
        children: [
          _renderDividerWithLabel(
            label: isSeedPoint ? '배팅 포인트' : '예측 성공 시 획득 가능 포인트',
          ),
          isSeedPoint
              ? Container(
                decoration: BoxDecoration(
                  color: backGroundColor ?? DARK_GREY_COLOR,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                height: 25.h,
                width: 132.w,
                child: Center(child: PointWithIcon(point: point)),
              )
              : Container(
                height: 35.h,
                width: 276.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: backGroundColor ?? BLACK_COLOR,
                  border: Border.all(color: borderColor!),
                ),
                child: Center(child: PointWithIcon(point: point)),
              ),
        ],
      ),
    );
  }

  Widget _renderDividerWithLabel({required String label}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Row(
        children: [
          Expanded(child: Divider(thickness: 1, color: DARK_GREY_COLOR)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
            child: Text(
              label,
              style: defaultTextStyle.copyWith(fontSize: 12.sp),
            ),
          ),
          Expanded(child: Divider(thickness: 1, color: DARK_GREY_COLOR)),
        ],
      ),
    );
  }

}
