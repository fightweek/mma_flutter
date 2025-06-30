import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mma_flutter/admin/event/repository/admin_event_repository.dart';
import 'package:mma_flutter/common/component/custom_alert_dialog.dart';
import 'package:mma_flutter/common/layout/default_layout.dart';

class UpcomingEventSaveScreen extends ConsumerWidget {
  const UpcomingEventSaveScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            OutlinedButton(
              onPressed: () async {
                try {
                  await ref.read(adminEventSaveUpcomingProvider.future);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('upcoming event 업데이트 성공')),
                  );
                } catch (e) {
                  log(e.toString());
                  showDialog(
                    context: context,
                    builder:
                        (_) => CustomAlertDialog(
                          titleMsg: '에러',
                          contentMsg: 'upcoming event update failure',
                        ),
                  );
                }
              },
              child: Text('다가오는 이벤트 업데이트'),
            ),
          ],
        ),
      ),
    );
  }
}
