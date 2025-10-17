import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/user/model/user_model.dart';

class PointWithIcon extends StatelessWidget {
  final int point;
  final Color? color;

  const PointWithIcon({required this.point, this.color, super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          WidgetSpan(
            child: SvgPicture.asset(
              'asset/img/icon/point.svg',
              height: 15.44,
              width: 15.44,
              colorFilter: ColorFilter.mode(
                color ?? Color(0xffFFFAF8),
                BlendMode.srcIn,
              ),
            ),
          ),
          WidgetSpan(child: SizedBox(width: 5.0)),
          TextSpan(
            text: point.toString(),
            style: TextStyle(
              fontSize: 14.sp,
              color: color ?? WHITE_COLOR,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
