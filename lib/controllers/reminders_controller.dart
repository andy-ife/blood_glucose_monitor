import 'package:blood_glucose_monitor/controllers/chat_controller.dart';
import 'package:blood_glucose_monitor/models/reminder.dart';
import 'package:blood_glucose_monitor/services/auth_service.dart';
import 'package:blood_glucose_monitor/services/notification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class RemindersController extends ChangeNotifier {
  late final FirebaseFirestore _firestore;
  late final NotificationService _notificationService;
  late final AuthService _authService;
  late RemindersState state;

  RemindersController()
    : _firestore = FirebaseFirestore.instance,
      _notificationService = NotificationService(),
      _authService = AuthService(),
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
    try {
      if (state.isAddingReminder) return;

      await _notificationService.requestNotificationPermissions();
      await Permission.ignoreBatteryOptimizations.request();

      state = state.copyWith(isAddingReminder: true);

      await _firestore.collection('reminders').add(reminder.toJson());
      _notificationService.scheduleNextReminder(
        id: reminder.id,
        patientName: _authService.user!.username,
        patientId: _authService.user!.id,
        doctorId: DOCTOR_ID,
        dosage: "1",
        unit: "Unit",
        medicineName: "Glucose Test",
        nextReminder: reminder.time!,
        endDate: null,
        notificationTimes: [
          _notificationService.formatTimeOfDay(
            TimeOfDay.fromDateTime(reminder.time!),
          ),
        ],
        frequency: [0, 1, 2, 3, 4, 5, 6],
      );

      state = state.copyWith(isAddingReminder: false);
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteReminder(int id) async {
    final reminders = await _firestore
        .collection('reminders')
        .where('id', isEqualTo: id)
        .get();

    for (var doc in reminders.docs) {
      await doc.reference.delete();
    }

    _notificationService.cancelNotification(id);
  }
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
