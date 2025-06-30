import 'package:flutter/material.dart';

class InputLabel extends StatelessWidget {
  final String title;
  final TextStyle? textStyle;

  const InputLabel({required this.title,this.textStyle, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, bottom: 5),
      child: Container(
        alignment: Alignment.topLeft,
        child: Text(title, style: textStyle ?? TextStyle(color: Colors.white)),
      ),
    );
  }
}
