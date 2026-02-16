import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static onTap(NotificationResponse notificationResponse) {}

  static Future init() async {
    final InitializationSettings settings = const InitializationSettings(android: AndroidInitializationSettings("@mipmap/ic_launcher"), iOS: DarwinInitializationSettings());
    flutterLocalNotificationsPlugin.initialize(settings, onDidReceiveNotificationResponse: onTap, onDidReceiveBackgroundNotificationResponse: onTap);
  }

  static Future<void> weeklySchduledNotification() async {
    final String channelId = '${DateTime.now().millisecondsSinceEpoch ~/ 2000000}';
    final AndroidNotificationDetails android = AndroidNotificationDetails(channelId, 'schduled notification', importance: Importance.max, priority: Priority.high, sound: RawResourceAndroidNotificationSound('sound.wav'.split('.').first), playSound: true);
    final NotificationDetails notificationDetails = NotificationDetails(android: android);
    tz.initializeTimeZones();
    final TimezoneInfo timezoneInfo = await FlutterTimezone.getLocalTimezone();
    final String currentTimeZone = timezoneInfo.identifier;

    tz.setLocalLocation(tz.getLocation(currentTimeZone.toString()));
    final currentTime = tz.TZDateTime.now(tz.local);
    log("local:${tz.local}");
    log("currentTime.year:${currentTime.year}");
    log("currentTime.month:${currentTime.month}");
    log("currentTime.day:${currentTime.day}");
    log("currentTime.hour:${currentTime.hour}");
    log("currentTime.minute:${currentTime.minute}");
    log("currentTime.second:${currentTime.second}");
    var scheduleTime = tz.TZDateTime(tz.local, currentTime.year, currentTime.month, currentTime.day, 12, 0);
    log("scheduledTime.year:${scheduleTime.year}");
    log("scheduledTime.month:${scheduleTime.month}");
    log("scheduledTime.day:${scheduleTime.day}");
    log("scheduledTime.hour:${scheduleTime.hour}");
    log("scheduledTime.minute:${scheduleTime.minute}");
    log("scheduledTime.second:${scheduleTime.second}");
    int daysUntilTarget = (DateTime.saturday - currentTime.weekday) % 7;
    if (daysUntilTarget == 0 && scheduleTime.isBefore(currentTime)) {
      // لو نفس اليوم لكن الوقت فات، زوّد أسبوع
      daysUntilTarget = 7;
    }
    scheduleTime = scheduleTime.add(Duration(days: daysUntilTarget));

    log("AfterAddedscheduledTime.year:${scheduleTime.year}");
    log("AfterAddedscheduledTime.month:${scheduleTime.month}");
    log("AfterAddedscheduledTime.day:${scheduleTime.day}");
    log("AfterAddedscheduledTime.hour:${scheduleTime.hour}");
    log("AfterAddedscheduledTime.minute:${scheduleTime.minute}");
    log("AfterAddedscheduledTime.second:${scheduleTime.second}");
    log('Added Duration to scheduled time');
    final int id = DateTime.now().millisecondsSinceEpoch ~/ 3000;
    await flutterLocalNotificationsPlugin.zonedSchedule(id, "ask".tr(), "body".tr(), scheduleTime, notificationDetails, androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
  }

  static Future<void> schduledNotification({required DateTime pickDate, required TimeOfDay pickTime, required String? title, required String? body}) async {
    final String channelId = '${DateTime.now().millisecondsSinceEpoch ~/ 1000000}';
    final AndroidNotificationDetails android = AndroidNotificationDetails(channelId, 'schduled notificatio2', importance: Importance.max, priority: Priority.high, sound: RawResourceAndroidNotificationSound('sound.wav'.split('.').first), playSound: true);
    final NotificationDetails notificationDetails = NotificationDetails(android: android);
    tz.initializeTimeZones();
    final TimezoneInfo timezoneInfo = await FlutterTimezone.getLocalTimezone();
    final String currentTimeZone = timezoneInfo.identifier;

    tz.setLocalLocation(tz.getLocation(currentTimeZone.toString()));

    final scheduleTime = tz.TZDateTime(tz.local, pickDate.year, pickDate.month, pickDate.day, pickTime.hour, pickTime.minute).subtract(const Duration(minutes: 1));

    final int id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    await flutterLocalNotificationsPlugin.zonedSchedule(id, title, body, scheduleTime, notificationDetails, androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle);
    log('Notification Scheduled for $pickDate with id $id and time ${pickTime.hour}:${pickTime.minute}');
  }

  static Future<void> requestNotificationPermission() async {
    final androidPlugin = flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.requestNotificationsPermission();
  }
}
