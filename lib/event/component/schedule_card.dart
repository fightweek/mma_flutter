import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mma_flutter/common/const/colors.dart';
import 'package:mma_flutter/event/provider/schedule_provider.dart';

import '../model/schedule_model.dart';

class ScheduleCard extends ConsumerWidget {
  final FightEventModel schedule;
  bool _hasTriggeredRefresh = false;
  final _defaultTextStyle = TextStyle(color: Colors.white, fontSize: 14);

  ScheduleCard({super.key, required this.schedule});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: MY_DARK_GREY_COLOR,
        borderRadius: BorderRadius.circular(10.0),
      ),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  schedule.name,
                  style: _defaultTextStyle.copyWith(fontSize: 24),
                ),
                if (schedule.date.isBefore(DateTime.now()))
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          '승자',
                          style: _defaultTextStyle.copyWith(fontSize: 20),
                        ),
                        Text(
                          '패자',
                          style: _defaultTextStyle.copyWith(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          ...schedule.fighterFightEvents.map(
            (e) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _imageCard(e.winnerImgPresignedUrl, ref),
                SizedBox(
                  height: 80,
                  width: 80,
                  child: Text(
                    '${e.winnerName.split(' ')[0]}\n${e.winnerName.split(' ')[1]}\n${e.winnerRecord.win}-${e.winnerRecord.loss}-${e.winnerRecord.draw}',
                    style: _defaultTextStyle,
                  ),
                ),
                SizedBox(
                  height: 80,
                  width: 80,
                  child: Text(
                    '${e.loserName.split(' ')[0]}\n${e.loserName.split(' ')[1]}\n${e.loserRecord.win}-${e.loserRecord.loss}-${e.loserRecord.draw}',
                    style: _defaultTextStyle,
                  ),
                ),
                _imageCard(e.loserImgPresignedUrl, ref),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool _isPresignedUrlExpired(Object error) {
    return error.toString().contains('403');
  }

   _imageCard(String presignedUrl, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        print('hello');
      },
      child: Image.network(
        height: 150,
        width: 150,
        presignedUrl,
        errorBuilder: (context, error, stackTrace) {
          print('----error-----');
          if (!_hasTriggeredRefresh && _isPresignedUrlExpired(error)) {
            print('--------403 error!!---------');
            _hasTriggeredRefresh = true;
            ref
                .read(scheduleProvider.notifier)
                .getSchedule(date: schedule.date, isRefresh: true);
            return CircularProgressIndicator();
          } else {
            return Container(
              color: MY_MIDDLE_GREY_COLOR,
              height: 150,
              width: 150,
            );
          }
        },
      ),
    );
  }
}
