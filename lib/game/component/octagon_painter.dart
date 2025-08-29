import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mma_flutter/common/const/colors.dart';

/**
 * 1. fill + num
 * 2. stroke + num => shouldRepaint
 * 3. fill + stroke
 *
 *
 */

class OctagonPainter extends CustomPainter {
  final Color? fillColor;
  final Color? strokeColor;
  final int? num;
  final double? width;
  final bool isEasy;
  final double? textSize;

  const OctagonPainter({
    required this.isEasy,
    this.num,
    this.width,
    this.fillColor,
    this.strokeColor,
    this.textSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    final radius = size.width / 2;
    final angle = 2 * pi / 8;

    for (int i = 0; i < 8; i++) {
      final x = size.width / 2 + radius * cos(-pi / 2 - i * angle);
      final y = size.height / 2 + radius * sin(-pi / 2 - i * angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();

    if (fillColor != null) {
      final fillPaint =
          Paint()
            ..color = fillColor!
            ..style = PaintingStyle.fill;
      canvas.drawPath(path, fillPaint);
      if (num != null) {
        drawText(size: size, canvas: canvas);
      }
    }
    if (strokeColor != null) {
      final strokePaint =
          Paint()
            ..color = strokeColor!
            ..style = PaintingStyle.stroke
            ..strokeWidth = width ?? 4.w
            ..strokeCap = StrokeCap.round;
      if (num != null) {
        final rate = isEasy ? 15 : 10;
        final percent = (num!.clamp(0, rate) / rate); // 1~10 → 0~1 비율
        final metrics = path.computeMetrics().first;
        final lengthToDraw = metrics.length * percent;

        final partialPath = metrics.extractPath(0, lengthToDraw);
        canvas.drawPath(partialPath, strokePaint);
        drawText(size: size, canvas: canvas);
      }else{
        canvas.drawPath(path, strokePaint);
      }
    }
  }

  void drawText({required Size size, required Canvas canvas}) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: num.toString(),
        style: TextStyle(color: WHITE_COLOR, fontSize: textSize ?? 18.sp),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    final offset = Offset(
      (size.width - textPainter.width) / 2,
      (size.height - textPainter.height) / 2,
    );
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant OctagonPainter oldDelegate) {
    return oldDelegate.num != num;
  }
}
