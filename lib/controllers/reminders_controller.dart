import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RemindersController extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  RemindersController() {
    fetchRemindersStream();
  }

  RemindersState state = RemindersState(
    currentUser: FirebaseAuth.instance.currentUser!,
    remindersStream: Stream.empty(),
  );

  Future<void> fetchRemindersStream() async {}
  Future<void> addReminder() async {}
  Future<void> deleteReminder() async {}
}

class RemindersState {
  final User currentUser;
  final Stream<QuerySnapshot> remindersStream;
  final bool hasErrorFetchingReminders;
  final bool isFetchingReminders;

  const RemindersState({
    required this.currentUser,
    required this.remindersStream,
    this.hasErrorFetchingReminders = false,
    this.isFetchingReminders = false,
  });

  RemindersState copyWith({
    User? currentUser,
    Stream<QuerySnapshot>? remindersStream,
    bool? hasErrorFetchingReminders,
    bool? isFetchingReminders,
  }) {
    return RemindersState(
      currentUser: currentUser ?? this.currentUser,
      remindersStream: remindersStream ?? this.remindersStream,
      hasErrorFetchingReminders:
          hasErrorFetchingReminders ?? this.hasErrorFetchingReminders,
      isFetchingReminders: isFetchingReminders ?? this.isFetchingReminders,
    );
  }
}
