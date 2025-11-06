import 'dart:async';

import 'package:blood_glucose_monitor/models/reading.dart';
import 'package:blood_glucose_monitor/services/glucose_data_service.dart';
import 'package:flutter/material.dart';

class HistoryController extends ChangeNotifier {
  final _service = GlucoseDataService();

  HistoryState state = HistoryState();

  final StreamController<String> _streamController = StreamController<String>();
  StreamSubscription? _subscription;

  final tabs = ['Today', 'Last 7 Days', 'Last Month', 'All'];

  HistoryController() {
    init();
    switchTimeframe('Today');
  }

  void init() {
    if (state.loading) return;
    state = state.copyWith(loading: true, error: '');

    _streamController.stream.asBroadcastStream().listen((streamIndex) {
      _subscription?.cancel();

      Stream<List<Reading>> targetStream;
      switch (streamIndex) {
        case 'Today':
          targetStream = _service.daily;
          break;
        case 'Last 7 Days':
          targetStream = _service.weekly;
          break;
        case 'Last Month':
          targetStream = _service.monthly;
          break;
        case 'All':
          targetStream = _service.all;
          break;
        default:
          print('Invalid stream index: $streamIndex');
          return;
      }

      _subscription = targetStream.listen(
        (value) {
          state = state.copyWith(loading: false, error: '', data: value);
          notifyListeners();
        },
        onError: (e) {
          state = state.copyWith(loading: false, error: e.toString());
          notifyListeners();
        },
      );
    });
  }

  void switchTimeframe(String tag) {
    _streamController.add(tag);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _streamController.close();
    super.dispose();
  }
}

class HistoryState {
  final bool loading;
  final String error;
  final List<Reading> data;

  const HistoryState({
    this.loading = false,
    this.error = '',
    this.data = const [],
  });

  HistoryState copyWith({bool? loading, String? error, List<Reading>? data}) =>
      HistoryState(
        loading: loading ?? this.loading,
        error: error ?? this.error,
        data: data ?? this.data,
      );
}
