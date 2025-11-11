import 'dart:io';

import 'package:alarm/alarm.dart';
import 'package:blood_glucose_monitor/models/reminder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class RemindersController extends ChangeNotifier {
  late final FirebaseFirestore _firestore;
  late RemindersState state;

  RemindersController()
    : _firestore = FirebaseFirestore.instance,
      state = RemindersState(remindersStream: Stream.empty()) {
    fetchRemindersStream();
  }

  Future<void> fetchRemindersStream() async {
    if (state.isFetchingReminders) return;

    state = state.copyWith(
      isFetchingReminders: true,
      hasErrorFetchingReminders: false,
    );
    notifyListeners();

    final stream = _firestore.collection('reminders').snapshots();

    state = state.copyWith(remindersStream: stream, isFetchingReminders: false);
    notifyListeners();
  }

  Future<void> addReminder(Reminder reminder) async {
    if (state.isAddingReminder) return;

    _checkAndroidScheduleExactAlarmPermission();

    state = state.copyWith(isAddingReminder: true);

    await _firestore.collection('reminders').add(reminder.toJson());
    await _addAlarm(reminder);

    state = state.copyWith(isAddingReminder: false);
  }

  Future<void> deleteReminder(int id) async {
    final reminders = await _firestore
        .collection('reminders')
        .where('id', isEqualTo: id)
        .get();

    for (var doc in reminders.docs) {
      await doc.reference.delete();
    }

    await Alarm.stop(id);
  }
}

Future<void> _checkAndroidScheduleExactAlarmPermission() async {
  final status = await Permission.scheduleExactAlarm.status;
  if (status.isDenied) {
    await Permission.scheduleExactAlarm.request();
  }
}

Future<void> _addAlarm(Reminder reminder) async {
  final alarmSettings = AlarmSettings(
    id: reminder.id,
    dateTime: reminder.time!,
    assetAudioPath: 'assets/alarm.wav',
    loopAudio: true,
    vibrate: true,
    warningNotificationOnKill: Platform.isIOS,
    androidFullScreenIntent: true,
    volumeSettings: VolumeSettings.fade(
      volume: 0.8,
      fadeDuration: Duration(seconds: 5),
      volumeEnforced: true,
    ),
    notificationSettings: NotificationSettings(
      title: 'Blood Glucose Monitor',
      body: reminder.description,
      stopButton: 'Dismiss',
      iconColor: Color(0xff862778),
    ),
  );

  await Alarm.set(alarmSettings: alarmSettings);
}

class RemindersState {
  final Stream<QuerySnapshot> remindersStream;
  final bool hasErrorFetchingReminders;
  final bool isFetchingReminders;
  final bool isAddingReminder;

  const RemindersState({
    required this.remindersStream,
    this.hasErrorFetchingReminders = false,
    this.isFetchingReminders = false,
    this.isAddingReminder = false,
  });

  RemindersState copyWith({
    Stream<QuerySnapshot>? remindersStream,
    bool? hasErrorFetchingReminders,
    bool? isFetchingReminders,
    bool? isAddingReminder,
  }) {
    return RemindersState(
      remindersStream: remindersStream ?? this.remindersStream,
      hasErrorFetchingReminders:
          hasErrorFetchingReminders ?? this.hasErrorFetchingReminders,
      isFetchingReminders: isFetchingReminders ?? this.isFetchingReminders,
      isAddingReminder: isAddingReminder ?? this.isAddingReminder,
    );
  }
}
