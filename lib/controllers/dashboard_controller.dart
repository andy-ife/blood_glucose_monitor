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

    final timer = Timer(Duration(seconds: 10), () {
      if (!_checkLoadingDone()) {
        state = state.copyWith(loading: false);
        notifyListeners();
      }
    });

    final latest = _service.latest.map((e) => ("latest", e));
    final daily = _service.daily.map((e) => ("daily", e));
    final recent = _service.recent(Duration(days: 1)).map((e) => ("recent", e));

    _stream =
        StreamGroup.merge([latest, daily, recent]).listen((data) {
          if (!timer.isActive) return;

          switch (data) {
            case ("latest", const (Reading)?):
              state = state.copyWith(currentTest: data.$2 as Reading?);
              state = state.copyWith(loading: _checkLoadingDone());
              break;
            case ("daily", const (List<Reading>)):
              state = state.copyWith(
                loading: _checkLoadingDone(),
                todayTests: data.$2 as List<Reading>,
              );
              break;
            case ("recent", const (List<Reading>)):
              state = state.copyWith(
                loading: _checkLoadingDone(),
                recentTests: data.$2 as List<Reading>,
              );
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

  bool _checkLoadingDone() {
    return state.currentTest != null;
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
