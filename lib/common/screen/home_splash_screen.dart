import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/common/layout/default_layout.dart';

class HomeSplashScreen extends StatelessWidget {
  static String get routeName => 'home_splash';

  const HomeSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 37.h, bottom: 13.h),
            child: _basicContainer(width: 233.w, height: 18.h),
          ),
          _basicContainer(width: 293.w, height: 58.h),
          Padding(
            padding: EdgeInsets.only(top: 36.h, bottom: 33.h),
            child: _basicContainer(width: 45.h, height: 34.w)
          ),
          _basicContainer(width: 293.w, height: 58.h),
          Padding(
            padding: EdgeInsets.only(top: 36.h, bottom: 42.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [_personShapeWidget(), _personShapeWidget()],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [_nameShapeContainer(), _nameShapeContainer()],
          ),
          Padding(
            padding: EdgeInsets.only(top: 26.h, bottom: 10.h),
            child: _basicContainer(width: 205.w, height: 18.h),
          ),
          _basicContainer(width: 230.w, height: 37.h)
        ],
      ),
    );
  }

  Container _nameShapeContainer() {
    return _basicContainer(height: 24.h, width: 162.w);
  }

  Column _personShapeWidget() {
    return Column(
      children: [
        Container(
          height: 66.h,
          width: 66.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: DARK_GREY_COLOR,
          ),
        ),
        SizedBox(height: 14.h),
        Container(
          height: 58.h,
          width: 138.w,
          decoration: BoxDecoration(
            color: DARK_GREY_COLOR,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(32.r),
              bottom: Radius.circular(8.r),
            ),
          ),
        ),
      ],
    );
  }

  Container _basicContainer({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: DARK_GREY_COLOR,
      ),
    );
  }
}
