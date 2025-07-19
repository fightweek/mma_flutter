import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mma_flutter/common/layout/default_layout.dart';
import 'package:mma_flutter/fight_event/model/fight_event_model.dart';
import 'package:mma_flutter/fight_event/provider/fight_event_provider.dart';

import '../../common/model/base_state_model.dart';
import '../component/fight_event_card.dart';

class FightEventDetailScreen extends ConsumerStatefulWidget {
  static String get routeName => 'event_detail';

  final DateTime date;
  final bool isStream;

  const FightEventDetailScreen({required this.date, required this.isStream, super.key});

  @override
  ConsumerState<FightEventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends ConsumerState<FightEventDetailScreen> {
  @override
  void initState() {
    log('initialize event_detail_screen!');
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(fightEventProvider.notifier).getSchedule(date: widget.date);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(fightEventProvider)[formatDateKey(widget.date)];

    if (state == null || state is StateLoading) {
      print('state : $state');
      return Center(child: CircularProgressIndicator());
    }

    if (state is StateError) {
      return ElevatedButton(
        onPressed: () {
          ref.read(fightEventProvider.notifier).getSchedule(date: widget.date);
        },
        child: Text('다시시도'),
      );
    }

    final event = state as StateData<FightEventModel>;

    return SizedBox.expand(
      child: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            ...event.data!.fighterFightEvents.map(
              (e) => FightEventCard(
                ffe: e,
                isUpcoming: event.data!.upcoming,
                isDetail: false,
                isStream: widget.isStream,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String formatDateKey(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

}
