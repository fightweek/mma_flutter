import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mma_flutter/common/const/colors.dart';

class FighterCardSkeleton extends StatelessWidget {
  const FighterCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 362.w,
      height: 86.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(width: 1.w, color: GREY_COLOR),
        color: BLACK_COLOR,
      ),
      child: Row(
        children: [
          Container(decoration: BoxDecoration(
            color: DARK_GREY_COLOR,
            borderRadius: BorderRadius.circular(8.r),
          ), width: 78.w, height: 70.h),
          SizedBox(width: 4.w,),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _labelContainer(height: 20.h),
              SizedBox(height: 2.h,),
              _labelContainer(height: 20.h),
              SizedBox(height: 2.h),
              _labelContainer(height: 16.h),
            ],
          ),
        ],
      ),
    );
  }

  Container _labelContainer({required double height}) {
    return Container(width: 70.w, height: height, color: DARK_GREY_COLOR);
  }
}
