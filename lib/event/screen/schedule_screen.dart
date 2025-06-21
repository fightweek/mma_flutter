import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/common/const/style.dart';
import 'package:mma_flutter/common/model/base_state.dart';
import 'package:mma_flutter/event/component/schedule_card.dart';
import 'package:mma_flutter/event/model/schedule_model.dart';
import 'package:mma_flutter/event/provider/schedule_provider.dart';
import 'package:table_calendar/table_calendar.dart';

class ScheduleScreen extends ConsumerStatefulWidget {
  const ScheduleScreen({super.key});

  @override
  ConsumerState<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(scheduleProvider);

    final defaultBoxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(6.0),
      border: Border.all(color: Colors.grey[500]!, width: 1.0),
    );

    return RefreshIndicator(
      onRefresh: () async {
        ref
            .read(scheduleProvider.notifier)
            .getSchedule(date: _selectedDay, isRefresh: true);
      },
      child: SizedBox.expand(
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: MY_DARK_GREY_COLOR,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TableCalendar(
                    headerStyle: const HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      leftChevronIcon: Icon(
                        Icons.chevron_left,
                        color: Colors.white,
                      ),
                      // ← 버튼 색상 지정
                      rightChevronIcon: Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                      ),
                      // → 버튼 색상 지정
                      titleTextStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    locale: 'ko_KR',
                    focusedDay: _focusedDay,
                    firstDay: DateTime(1950),
                    lastDay: DateTime(DateTime.now().year + 1),
                    calendarStyle: CalendarStyle(
                      todayDecoration: defaultBoxDecoration.copyWith(
                        border: Border.all(
                          color: Colors.grey[500]!,
                          width: 1.0,
                        ),
                      ),
                      defaultDecoration: defaultBoxDecoration,
                      weekendDecoration: defaultBoxDecoration,
                      defaultTextStyle: defaultTextStyle,
                      weekendTextStyle: defaultTextStyle,
                      selectedDecoration: defaultBoxDecoration.copyWith(
                        border: Border.all(color: Colors.lightBlue, width: 1.0),
                      ),
                    ),
                    onDaySelected: onDaySelected,
                    selectedDayPredicate: selectedDayPredicate,
                  ),
                ),
              ),
              if (state[formatDateKey(_selectedDay)] is StateLoading)
                CircularProgressIndicator()
              else
                showSchedule(state[formatDateKey(_selectedDay)]),
            ],
          ),
        ),
      ),
    );
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
      print('selectedDay=$selectedDay');
      print('focusedDay=$focusedDay');
    });
    ref.read(scheduleProvider.notifier).getSchedule(date: _selectedDay);
  }

  bool selectedDayPredicate(DateTime day) {
    return day.isAtSameMomentAs(_selectedDay);
  }

  Widget showSchedule(StateBase<FightEventModel>? state) {
    if (state == null) {
      return CircularProgressIndicator();
    }
    if (state is StateError) {
      return ElevatedButton(
        onPressed: () {
          ref
              .read(scheduleProvider.notifier)
              .getSchedule(date: _selectedDay, isRefresh: true);
        },
        child: Text('다시시도'),
      );
    }
    final currentStateData = state as StateData<FightEventModel>;
    if (currentStateData.data != null) {
      return Column(
        children: [
          ScheduleCard.header(currentStateData.data!.name),
          ...currentStateData.data!.fighterFightEvents.map(
            (e) => ScheduleCard(ffe: e),
          ),
        ],
      );
    } else {
      return _EmptyCard();
    }
  }

  String formatDateKey(DateTime date) => DateFormat('yyyy-MM-dd').format(date);
}

class _EmptyCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: MY_DARK_GREY_COLOR,
      child: Text('일정이 없습니다.', style: TextStyle(color: Colors.white)),
    );
  }
}
