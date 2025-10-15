import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/common/const/style.dart';
import 'package:mma_flutter/common/model/base_state_model.dart';
import 'package:mma_flutter/fight_event/component/fight_event_card_header.dart';
import 'package:mma_flutter/fight_event/component/fight_event_card_list.dart';
import 'package:mma_flutter/fight_event/model/fight_event_model.dart';
import 'package:mma_flutter/fight_event/provider/fight_event_provider.dart';
import 'package:mma_flutter/fight_event/screen/fight_event/component/fight_event_date_picker.dart';
import 'package:table_calendar/table_calendar.dart';

class FightEventScreen extends ConsumerStatefulWidget {
  const FightEventScreen({super.key});

  @override
  ConsumerState<FightEventScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<FightEventScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  DateTime? _datePickerDay;

  @override
  Widget build(BuildContext context) {
    final defaultBoxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(8.r),
    );

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: BLACK_COLOR,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: TableCalendar(
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
              rightChevronIcon: Icon(
                Icons.chevron_right,
                color: Colors.white,
              ),
              titleTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 17.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            locale: 'ko_KR',
            focusedDay: _focusedDay,
            firstDay: DateTime(1950),
            lastDay: DateTime(DateTime.now().year + 1),
            calendarStyle: CalendarStyle(
              todayDecoration: defaultBoxDecoration,
              outsideDecoration: defaultBoxDecoration.copyWith(
                border: Border.all(color: Colors.transparent),
              ),
              defaultDecoration: defaultBoxDecoration,
              weekendDecoration: defaultBoxDecoration,
              defaultTextStyle: defaultTextStyle,
              weekendTextStyle: defaultTextStyle,
              selectedDecoration: defaultBoxDecoration.copyWith(
                color: BLUE_COLOR,
              ),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: defaultTextStyle.copyWith(color: Colors.grey),
              weekendStyle: defaultTextStyle.copyWith(color: Colors.grey),
            ),
            onDaySelected: onDaySelected,
            selectedDayPredicate: selectedDayPredicate,
            onHeaderTapped: (focusedDay) {
              showCupertinoModalPopup(
                context: context,
                builder:
                    (_) => FightEventDatePicker(
                      onDateTimeChanged: (val) {
                        _datePickerDay = val;
                      },
                      focusedDay: _focusedDay,
                      datePickerButtonPressed: () {
                        if (_datePickerDay != null) {
                          onDaySelected(_datePickerDay!, _datePickerDay!);
                        }
                      },
                    ),
              );
            },
          ),
        ),
      ],
    );
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
    ref.read(fightEventProvider.notifier).getSchedule(date: _selectedDay);
    showSchedule();
  }

  bool selectedDayPredicate(DateTime day) {
    return day.isAtSameMomentAs(_selectedDay);
  }

  showSchedule() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showModalBottomSheet(
        constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width,
        ),
        backgroundColor: DARK_GREY_COLOR,
        context: context,
        isScrollControlled: true,
        enableDrag: true,
        showDragHandle: true,
        builder: (context) {
          return Consumer(
            builder: (context, ref, child) {
              final state =
                  ref.watch(fightEventProvider)[formatDateKey(_selectedDay)];
              return DraggableScrollableSheet(
                expand: false,
                initialChildSize: 0.4,
                // 기본 높이: 화면 절반
                minChildSize: 0.4,
                maxChildSize: 1.0,
                builder: (context, scrollController) {
                  if (state == null || state is StateLoading) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (state is StateError) {
                    return Center(
                      child: ElevatedButton(
                        onPressed: () {
                          ref
                              .read(fightEventProvider.notifier)
                              .getSchedule(date: _selectedDay, isRefresh: true);
                        },
                        child: Text('다시시도'),
                      ),
                    );
                  }
                  final currentStateData = state as StateData<FightEventModel>;
                  if (currentStateData.data != null) {
                    return SafeArea(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          ref
                              .read(fightEventProvider.notifier)
                              .getSchedule(date: _selectedDay, isRefresh: true);
                        },
                        child: SingleChildScrollView(
                          controller: scrollController,
                          physics: AlwaysScrollableScrollPhysics(),
                          child: Column(
                            children: [
                              FightEventCardHeader(
                                eventId: currentStateData.data!.id,
                                eventName: currentStateData.data!.name,
                                eventStartDateTimeInfo:
                                    currentStateData
                                        .data!
                                        .earlyCardDateTimeInfo ??
                                    currentStateData.data!.prelimCardDateTimeInfo,
                              ),
                              FightEventCardList(
                                ife: currentStateData.data!,
                                stream: false,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Text(
                      '일정이 없습니다.',
                      style: TextStyle(color: WHITE_COLOR),
                    );
                  }
                },
              );
            },
          );
        },
      );
    });
  }
}

String formatDateKey(DateTime date) => DateFormat('yyyy-MM-dd').format(date);
