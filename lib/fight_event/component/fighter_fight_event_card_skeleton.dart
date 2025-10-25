import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mma_flutter/common/const/colors.dart';

class FighterFightEventCardSkeleton extends StatelessWidget {
  final bool isHeaderIncluded;

  const FighterFightEventCardSkeleton({
    required this.isHeaderIncluded,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (isHeaderIncluded) _headerContainer(),
        Container(
          width: 362.w,
          height: 86.h,
          decoration: BoxDecoration(
            color: BLACK_COLOR,
            borderRadius: BorderRadius.circular(8.r),
            border: BoxBorder.all(color: GREY_COLOR, width: 1.w),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: _basicContainer(height: 55.h, width: 86.w),
              )),
              _labelsContainer(),
              SizedBox(width: 4.w,),
              _basicContainer(width: 24.w, height: 20.h),
              SizedBox(width: 4.w,),
              _labelsContainer(),
              Expanded(child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: _basicContainer(height: 55.h, width: 86.w),
              )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _headerContainer() {
    return Column(
      children: [
        _basicContainer(height: 15.h, width: 300.w),
        SizedBox(height: 8.h),
      ],
    );
  }

  Widget _labelsContainer() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _labelContainer(height: 20.h),
        SizedBox(height: 2.h),
        _labelContainer(height: 20.h),
        SizedBox(height: 2.h),
        _labelContainer(height: 16.h),
      ],
    );
  }

  Container _labelContainer({required double height}) {
    return _basicContainer(width: 70.w, height: height);
  }

  Container _basicContainer({
    required double width,
    required double height,
    Widget? child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: DARK_GREY_COLOR,
        borderRadius: BorderRadius.circular(8.r),
      ),
      height: height,
      width: width,
      child: child,
    );
  }
}
