import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gradient_borders/gradient_borders.dart';
import 'package:mma_flutter/common/const/colors.dart';

final defaultTextStyle = TextStyle(
  color: WHITE_COLOR,
  fontWeight: FontWeight.w500,
  fontSize: 15.sp
);

final linearGradientInputBorder = GradientOutlineInputBorder(
    gradient: LinearGradient(colors: [
      Colors.blue,Colors.red,
    ]),
    borderRadius: BorderRadius.circular(8.r),
    width: 2.w
);