import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;

const String takenActionId = 'stop_alarm';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) {
  if (response.actionId == takenActionId) {
    return; // Do nothing
  }
}

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void scheduleNextReminder({
    required int id,
    required String patientName,
    required String patientId,
    required String doctorId,
    required String dosage,
    required String unit,
    required String medicineName,
    required DateTime nextReminder,
    required List<String> notificationTimes,
    required List<int> frequency,
    DateTime? endDate,
  }) {
    final payload = {
      "name": patientName,
      "dosage": dosage,
      "patientId": patientId,
      "doctorId": doctorId,
      "unit": unit,
      "medicineName": medicineName,
      "expectedTime":
          "${formatTimeOfDay(TimeOfDay(hour: nextReminder.hour, minute: nextReminder.minute))} on ${formatDate(nextReminder)}",
    };
    _scheduleNotification(
      id,
      "Hi $patientName It's Time",
      "To take Your Glucose Test",
      nextReminder,
      endDate,
      notificationTimes,
      daysOfTheWeek: frequency,
      payload: jsonEncode(payload),
    );
  }

  // Schedule a notification
  Future<void> _scheduleNotification(
    int id,
    String title,
    String body,
    DateTime scheduleTime,
    DateTime? endDate,
    List<String> notificationTimes, {
    String? qrCode,
    String? payload,
    List<int> daysOfTheWeek = const [],
  }) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'BGM CHANNEL$id',
          'BGM PATIENT CHANNEL',
          channelDescription: 'Remember to take your glucose medication',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          autoCancel: true,
          ongoing: true,
          fullScreenIntent: true,
          channelBypassDnd: true,
          ticker: title,
          enableVibration: true,
          vibrationPattern: Int64List.fromList([
            0,
            1000,
            2000,
            1000,
            2000,
            1000,
            2000,
            1000,
            2000,
            1000,
            2000,
            1000,
          ]),
          timeoutAfter: 30000 * 60,
          // 30 seconds * 60 = 30 minutes
          visibility: NotificationVisibility.public,
          actions: [
            const AndroidNotificationAction(
              takenActionId,
              'TEST TAKEN',
              cancelNotification: true,
            ),
            // const AndroidNotificationAction(
            //     snoozeActionId, 'SNOOZE FOR 5 MINUTES'),
          ],
        );
    DarwinNotificationDetails iosPlatformChannelSpecifics =
        DarwinNotificationDetails(
          interruptionLevel: InterruptionLevel.critical,
          presentSound: true,
          categoryIdentifier: "",
        );
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iosPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduleTime, tz.local),
      notificationDetails,
      scheduledEndDate: endDate == null
          ? null
          : tz.TZDateTime.from(endDate, tz.local),
      daysOfTheWeek: daysOfTheWeek,
      notificationTimes: notificationTimes,
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.alarmClock,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  void cancelNotification(id) {
    flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<bool> isAndroidPermissionGranted() async {
    if (Platform.isAndroid) {
      final bool granted =
          await flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >()
              ?.areNotificationsEnabled() ??
          false;

      return granted;
    }
    return true;
  }

  Future<bool> requestNotificationPermissions() async {
    if (await Permission.scheduleExactAlarm.isDenied) {
      await Permission.scheduleExactAlarm.request();
    }
    if (Platform.isIOS) {
      return await flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                IOSFlutterLocalNotificationsPlugin
              >()
              ?.requestPermissions(
                alert: true,
                badge: true,
                sound: true,
                critical: true,
              ) ??
          false;
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();
      return await androidImplementation?.requestNotificationsPermission() ??
          false;
    }
    return true;
  }

  String formatTimeOfDay(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0
        ? 12
        : time.hourOfPeriod; // Handle 12-hour format
    final minute = time.minute.toString().padLeft(
      2,
      '0',
    ); // Ensure two-digit minutes
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';

    return '$hour:$minute $period';
  }

  String formatDate(DateTime date, {bool showTime = false}) {
    // Get the day with ordinal suffix (1st, 2nd, 3rd, etc.)
    String getDayWithSuffix(int day) {
      if (day >= 11 && day <= 13) return '${day}th';
      switch (day % 10) {
        case 1:
          return '${day}st';
        case 2:
          return '${day}nd';
        case 3:
          return '${day}rd';
        default:
          return '${day}th';
      }
    }

    // Map of month numbers to names
    const List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    String dayWithSuffix = getDayWithSuffix(date.day);
    String month = months[date.month - 1];
    String year = date.year.toString();

    // Format: "1st Oct, 2024"
    return '$dayWithSuffix $month, $year${showTime ? ' | ${formatTimeOfDay(TimeOfDay(hour: date.hour, minute: date.minute))}' : ''}';
  }
}
