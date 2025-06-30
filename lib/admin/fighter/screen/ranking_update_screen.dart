import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mma_flutter/admin/fighter/repository/admin_fighter_repository.dart';
import 'package:mma_flutter/common/component/custom_alert_dialog.dart';
import 'package:mma_flutter/common/const/style.dart';
import 'package:mma_flutter/common/layout/default_layout.dart';

class RankingUpdateScreen extends ConsumerWidget {
  const RankingUpdateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            OutlinedButton(
              onPressed: () async {
                try {
                  await ref.read(adminFighterUpdateProvider.future);
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('랭킹 업데이트 성공')));
                } catch (e) {
                  log(e.toString());
                  showDialog(
                    context: context,
                    builder:
                        (_) => CustomAlertDialog(
                          titleMsg: '에러',
                          contentMsg: '랭킹 업데이트 오류',
                        ),
                  );
                }
              },
              child: Text('랭킹 업데이트'),
            ),
          ],
        ),
      ),
    );
  }
}
