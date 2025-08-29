import 'dart:math';
import 'package:flutter/material.dart';

class OctagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final radius = size.width / 2;
    final angle = 2 * pi / 8; // 8각형

    for (int i = 0; i < 8; i++) {
      final x = size.width / 2 + radius * cos(-pi / 2 + i * angle);
      final y = size.height / 2 + radius * sin(-pi / 2 + i * angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}