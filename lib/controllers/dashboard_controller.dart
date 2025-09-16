import 'dart:async';

import 'package:async/async.dart';
import 'package:blood_glucose_monitor/models/reading.dart';
import 'package:blood_glucose_monitor/services/glucose_data_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DashboardController extends ChangeNotifier {
  final _service = GlucoseDataService();
  StreamSubscription? _stream;

  DashboardState state = DashboardState(
    currentUser: FirebaseAuth.instance.currentUser!,
  );

  DashboardController() {
    init();
  }

  void init() {
    if (state.loading) return;

    _stream?.cancel();

    state = state.copyWith(loading: true, error: '');
    notifyListeners();

    final latest = _service.latest.map((e) => ("latest", e));
    final daily = _service.daily.map((e) => ("daily", e));
    final recent = _service.recent(Duration(days: 1)).map((e) => ("recent", e));

    _stream =
        StreamGroup.merge([latest, daily, recent]).listen((data) {
          state = state.copyWith(loading: false);
          final (tag, value) = data;
          switch (tag) {
            case "latest":
              state = state.copyWith(currentTest: value as Reading);
              break;
            case "daily":
              state = state.copyWith(todayTests: value as List<Reading>);
              break;
            case "recent":
              state = state.copyWith(recentTests: value as List<Reading>);
              break;
            default:
              break;
          }
          notifyListeners();
        })..onError((e) {
          state = state.copyWith(loading: false, error: e.toString());
          notifyListeners();
        });
  }

  @override
  void dispose() {
    _stream?.cancel();
    super.dispose();
  }
}

class DashboardState {
  final bool loading;
  final String error;
  final User currentUser;
  final Reading? currentTest;
  final List<Reading> todayTests;
  final List<Reading> recentTests;

  const DashboardState({
    this.loading = false,
    this.error = '',
    required this.currentUser,
    this.currentTest,
    this.todayTests = const [],
    this.recentTests = const [],
  });

  DashboardState copyWith({
    bool? loading,
    User? currentUser,
    String? error,
    Reading? currentTest,
    List<Reading>? todayTests,
    List<Reading>? recentTests,
  }) => DashboardState(
    currentUser: currentUser ?? this.currentUser,
    loading: loading ?? this.loading,
    currentTest: currentTest ?? this.currentTest,
    recentTests: recentTests ?? this.recentTests,
    todayTests: todayTests ?? this.todayTests,
    error: error ?? this.error,
  );
}
