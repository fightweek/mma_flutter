import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String titleMsg;
  final String contentMsg;
  final List<Widget>? actions;

  const CustomAlertDialog({
    required this.titleMsg,
    required this.contentMsg,
    this.actions,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(titleMsg),
      content: Text(contentMsg),
      actions:
          actions ??
          [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('닫기'),
            ),
          ],
    );
  }
}
