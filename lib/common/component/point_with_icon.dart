import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/user/model/user_model.dart';

class PointWithIcon extends StatelessWidget {

  final UserModel user;

  const PointWithIcon({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          WidgetSpan(
            child: Image.asset('asset/img/icon/point.png',color: Color(0xffFFFAF8),)
          ),
          WidgetSpan(child: SizedBox(width: 4.0)),
          TextSpan(
            text: user.point.toString(),
            style: TextStyle(fontSize: 15.sp, color: WHITE_COLOR),
          ),
        ],
      ),
    );
  }
}
