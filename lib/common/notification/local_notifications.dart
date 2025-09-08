import 'dart:async';
import 'dart:io';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotifications {
  static final FlutterLocalNotificationsPlugin
  _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static final StreamController<String?> notificationStream =
      StreamController<String?>.broadcast();

  static void onNotificationTap(NotificationResponse notificationResponse) {
    notificationStream.add(notificationResponse.payload!);
  }

  static Future init() async {
    // android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    // ios
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings();
    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsDarwin,
        );

    // android 푸시 알림 권한 요청
    if (Platform.isAndroid) {
      _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()!
          .requestNotificationsPermission();
    }

    // 푸시 알림 탭 시 호출되는 콜백 함수 등록
    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: onNotificationTap,
    );
  }

  // 특정 스케줄에 푸시 알림 보내기
  static showScheduleNotification({
    required int eventId,
    required String title,
    required String body,
    required String payload,
    required tz.TZDateTime scheduledDate,
  }) {
    tz.initializeTimeZones();
    _flutterLocalNotificationsPlugin.zonedSchedule(
      eventId,
      title,
      body,
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'channel_2',
          '경기 알림',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: payload,
    );
  }

  static void cancelNotification({required int eventId}){
    _flutterLocalNotificationsPlugin.cancel(eventId);
  }
}
