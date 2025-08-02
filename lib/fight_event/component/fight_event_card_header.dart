import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mma_flutter/common/const/style.dart';
import 'package:mma_flutter/common/notification/local_notifications.dart';
import 'package:mma_flutter/fight_event/model/card_date_time_info_model.dart';
import 'package:mma_flutter/fight_event/provider/fight_event_alert_provider.dart';
import 'package:mma_flutter/fight_event/provider/fight_event_provider.dart';
import 'package:mma_flutter/fighter/model/update_preference_model.dart';
import 'package:timezone/timezone.dart' as tz;

/**
 * required int eventId,
    required DateTime eventDate,
    required String eventName,
    required bool fighterDetail,
    required bool upcoming,
 */
class FightEventCardHeader extends ConsumerWidget {
  final int eventId;
  final String eventName;
  final CardDateTimeInfoModel? eventStartDateTimeInfo;

  const FightEventCardHeader({
    super.key,
    required this.eventId,
    required this.eventName,
    required this.eventStartDateTimeInfo,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOn = ref.watch(eventAlertStatusProvider(eventId));

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          if (eventStartDateTimeInfo != null)
            SizedBox(
              width: 36.0,
              child: InkWell(
                splashColor: Colors.blueAccent,
                onTap: () {
                  final scheduledDate = tz.TZDateTime.from(
                    // eventStartDateTime.subtract(Duration(days: 1)),
                    DateTime.now().add(Duration(seconds: 10)),
                    tz.local,
                  );
                  if (!isOn) {
                    LocalNotifications.showScheduleNotification(
                      eventId: eventId,
                      title: '경기 하루 전입니다!',
                      body: '내일은 $eventName 경기가 있습니다!',
                      payload: eventName,
                      scheduledDate: scheduledDate,
                    );
                  } else {
                    LocalNotifications.cancelNotification(eventId: eventId);
                  }
                  ref
                      .read(fightEventProvider.notifier)
                      .updatePreference(
                        model: UpdatePreferenceModel(
                          category: PreferenceCategory.alert,
                          targetId: eventId,
                          on: !isOn,
                        ),
                      );
                  ref.read(eventAlertStatusProvider(eventId).notifier).state =
                      !isOn;
                },
                child: Icon(
                  isOn ? FontAwesomeIcons.solidBell : FontAwesomeIcons.bell,
                  color: Colors.white,
                ),
              ),
            ),
          Flexible(
            child: Text(
              textAlign: TextAlign.center,
              eventName,
              style: defaultTextStyle.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
