import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mma_flutter/admin/event/repository/admin_event_repository.dart';
import 'package:mma_flutter/admin/fighter/repository/admin_fighter_repository.dart';
import 'package:mma_flutter/admin/provider/common_update_provider.dart';
import 'package:mma_flutter/admin/stream/repository/admin_stream_repository.dart';
import 'package:mma_flutter/common/component/custom_alert_dialog.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/common/model/base_state_model.dart';

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
              _renderAdminButton(
                context,
                ref: ref,
                buttonName: '랭킹 업데이트',
                provider: adminFighterUpdateProvider,
              ),
              _renderAdminButton(
                context,
                ref: ref,
                buttonName: '실시간 채팅방 활성화',
                provider: adminStreamUpdateProvider,
              ),
              _renderAdminButton(
                context,
                ref: ref,
                buttonName: '차후 이벤트 업데이트',
                provider: adminEventUpdateProvider,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _renderAdminButton(
    BuildContext context, {
    required WidgetRef ref,
    required String buttonName,
    required StateNotifierProvider<CommonUpdateStateNotifier, StateBase<void>?>
    provider,
  }) {
    final val = ref.watch(provider);
    if (val == null) {
      return OutlinedButton(
        onPressed: () {
          ref.read(provider.notifier).update();
        },
        child: Text(buttonName),
      );
    }
    if (val is StateLoading) {
      return Center(child: CircularProgressIndicator());
    }
    if (val is StateError) {
      return ElevatedButton(
        onPressed: () {
          ref.read(provider.notifier).update();
        },
        child: Text('$buttonName 다시시도 (오류 이유 : ${val.message})'),
      );
    }
    return OutlinedButton(
      onPressed: () {
        ref.read(provider.notifier).update();
      },
      child: Text(buttonName),
    );
  }
}
