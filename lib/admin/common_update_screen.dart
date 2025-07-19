import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mma_flutter/admin/event/repository/admin_event_repository.dart';
import 'package:mma_flutter/admin/fighter/repository/admin_fighter_repository.dart';
import 'package:mma_flutter/admin/stream/repository/admin_stream_repository.dart';
import 'package:mma_flutter/common/component/custom_alert_dialog.dart';
import 'package:mma_flutter/common/const/style.dart';
import 'package:mma_flutter/common/layout/default_layout.dart';

class RankingUpdateScreen extends ConsumerWidget {
  const RankingUpdateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
              OutlinedButton(
                onPressed: () async {
                  try {
                    await ref.read(adminActivateStreamRoomProvider.future);
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('실시간 채팅방 활성화 성공')));
                  } catch (e) {
                    log(e.toString());
                    showDialog(
                      context: context,
                      builder:
                          (_) => CustomAlertDialog(
                        titleMsg: '에러',
                        contentMsg: '실시간 채팅방 활성화 오류',
                      ),
                    );
                  }
                },
                child: Text('실시간 채팅방 활성화'),
              ),
              OutlinedButton(
                onPressed: () async {
                  try {
                    await ref.read(adminEventSaveUpcomingProvider.future);
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text('차후 이벤트 업데이트 성공')));
                  } catch (e) {
                    log(e.toString());
                    showDialog(
                      context: context,
                      builder:
                          (_) => CustomAlertDialog(
                        titleMsg: '에러',
                        contentMsg: '차후 이벤트 업데이트 오류',
                      ),
                    );
                  }
                },
                child: Text('차후 이벤트 업데이트'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
