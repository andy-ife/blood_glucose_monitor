import 'dart:async';

import 'package:async/async.dart';
import 'package:blood_glucose_monitor/models/reading.dart';
import 'package:blood_glucose_monitor/services/glucose_data_service.dart';
import 'package:flutter/material.dart';

class DashboardController extends ChangeNotifier {
  late final GlucoseDataService _service;
  late DashboardState state;
  StreamSubscription? _stream;

  DashboardController()
    : _service = GlucoseDataService(),
      state = DashboardState() {
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
    final weekly = _service.weekly.map((e) => ("weekly", e));
    final monthly = _service.monthly.map((e) => ("monthly", e));
    final all = _service.all.map((e) => ("all", e));

    _stream =
        StreamGroup.merge([latest, daily, recent, weekly, monthly, all]).listen(
          (data) {
            state = state.copyWith(loading: false);
            final (tag, value) = data;
            switch (tag) {
              case "latest":
                state = state.copyWith(currentTest: value as Reading);
                break;
              case "weekly":
                state = state.copyWith(weeklyTests: value as List<Reading>);
                break;
              case "monthly":
                state = state.copyWith(monthlyTests: value as List<Reading>);
                break;
              case "all":
                state = state.copyWith(allTests: value as List<Reading>);
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
          },
        )..onError((e) {
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
  final Reading? currentTest;
  final List<Reading> todayTests;
  final List<Reading> weeklyTests;
  final List<Reading> monthlyTests;
  final List<Reading> allTests;
  final List<Reading> recentTests;

  const DashboardState({
    this.loading = false,
    this.error = '',
    this.currentTest,
    this.todayTests = const [],
    this.recentTests = const [],
    this.allTests = const [],
    this.weeklyTests = const [],
    this.monthlyTests = const [],
  });

  DashboardState copyWith({
    bool? loading,
    String? error,
    Reading? currentTest,
    List<Reading>? todayTests,
    List<Reading>? recentTests,
    List<Reading>? weeklyTests,
    List<Reading>? monthlyTests,
    List<Reading>? allTests,
  }) => DashboardState(
    loading: loading ?? this.loading,
    currentTest: currentTest ?? this.currentTest,
    recentTests: recentTests ?? this.recentTests,
    todayTests: todayTests ?? this.todayTests,
    weeklyTests: weeklyTests ?? this.weeklyTests,
    monthlyTests: monthlyTests ?? this.monthlyTests,
    allTests: allTests ?? this.allTests,
    error: error ?? this.error,
  );
}
