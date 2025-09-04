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
    final state = ref.watch(fightEventProvider);

    final defaultBoxDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(8.0),
    );

    return RefreshIndicator(
      onRefresh: () async {
        ref
            .read(fightEventProvider.notifier)
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
                    color: DARK_GREY_COLOR,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TableCalendar(
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      leftChevronIcon: Icon(
                        Icons.chevron_left,
                        color: Colors.white,
                      ),
                      rightChevronIcon: Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                      ),
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
                      weekdayStyle: defaultTextStyle.copyWith(
                        color: Colors.grey,
                      ),
                      weekendStyle: defaultTextStyle.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                    onDaySelected: onDaySelected,
                    selectedDayPredicate: selectedDayPredicate,
                    onHeaderTapped: (focusedDay) {
                      showCupertinoModalPopup(
                        context: context,
                        builder:
                            (_) => SafeArea(
                              child: Container(
                                height: 300,
                                color: DARK_GREY_COLOR,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 250,
                                      child: CupertinoTheme(
                                        data: CupertinoThemeData(
                                          textTheme: CupertinoTextThemeData(
                                            textStyle: defaultTextStyle,
                                          ),
                                        ),
                                        child: CupertinoDatePicker(
                                          backgroundColor: DARK_GREY_COLOR,
                                          dateOrder: DatePickerDateOrder.ymd,
                                          mode:
                                              CupertinoDatePickerMode.monthYear,
                                          initialDateTime: _focusedDay,
                                          minimumDate: DateTime(1950),
                                          maximumDate: DateTime(
                                            DateTime.now().year + 1,
                                          ),
                                          onDateTimeChanged: (val) {
                                            _datePickerDay = val;
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 31.h,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            style: ElevatedButton.styleFrom(
                                              fixedSize: Size(135.w, 31.h),
                                              backgroundColor: Color(
                                                0xff8c8c8c,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                            ),
                                            child: Text(
                                              '닫기',
                                              style: defaultTextStyle,
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                                            child: ElevatedButton(
                                              onPressed: () {
                                                if (_datePickerDay != null) {
                                                  onDaySelected(
                                                    _datePickerDay!,
                                                    _datePickerDay!,
                                                  );
                                                }
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: BLUE_COLOR,
                                                fixedSize: Size(135.w, 31.h),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8.0),
                                                ),
                                              ),
                                              child: Text(
                                                '확인',
                                                style: defaultTextStyle,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                      );
                    },
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
    ref.read(fightEventProvider.notifier).getSchedule(date: _selectedDay);
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
              .read(fightEventProvider.notifier)
              .getSchedule(date: _selectedDay, isRefresh: true);
        },
        child: Text('다시시도'),
      );
    }
    final currentStateData = state as StateData<FightEventModel>;
    if (currentStateData.data != null) {
      return Column(
        children: [
          FightEventCardHeader(
            eventId: currentStateData.data!.id,
            eventName: currentStateData.data!.name,
            eventStartDateTimeInfo:
                currentStateData.data!.earlyCardDateTimeInfo ??
                currentStateData.data!.prelimCardDateTimeInfo,
          ),
          FightEventCardList(ife: currentStateData.data!, stream: false),
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
      color: DARK_GREY_COLOR,
      child: Text('일정이 없습니다.', style: TextStyle(color: Colors.white)),
    );
  }
}
