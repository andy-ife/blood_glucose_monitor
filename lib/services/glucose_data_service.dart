import 'package:blood_glucose_monitor/models/reading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GlucoseDataService {
  final _stream = FirebaseFirestore.instance
      .collection('Readings')
      .orderBy('timestamp', descending: true)
      .snapshots()
      .map(
        (event) => event.docs.map((d) => Reading.fromJson(d.data())).toList(),
      );

  Stream<Reading?> get latest => _stream.map((event) => event.firstOrNull);

  Stream<List<Reading>> get daily => _stream.map((data) => _groupByHour(data));

  Stream<List<Reading>> get weekly => _stream.map((data) => _groupByDay(data));

  Stream<List<Reading>> get monthly =>
      _stream.map((data) => _groupByWeek(data, weeks: 4));

  Stream<List<Reading>> recent(Duration duration) {
    return _stream.map(
      (data) => data
          .where((d) => d.time.isAfter(DateTime.now().subtract(duration)))
          .toList(),
    );
  }

  List<Reading> _groupByHour(List<Reading> readings) {
    final cutoff = DateTime.now().subtract(Duration(hours: 24));
    final recent = readings.where((r) => r.time.isAfter(cutoff)).toList();

    final List<Reading> grouped = [];

    for (int hour = 0; hour < 24; hour++) {
      final hourlyReadings = recent.where((r) => r.time.hour == hour).toList();

      if (hourlyReadings.isNotEmpty) {
        final avgGlucose =
            hourlyReadings.map((r) => r.glucose).reduce((a, b) => a + b) /
            hourlyReadings.length;

        grouped.add(
          Reading(
            glucose: avgGlucose,
            time: DateTime.now(),
            xAxis: hour,
            chartLabel: "${hour.toString().padLeft(2, '0')}:00",
          ),
        );
      }
    }

    return grouped;
  }

  List<Reading> _groupByDay(List<Reading> readings) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final List<Reading> grouped = [];

    for (int i = 6; i >= 0; i--) {
      final targetDay = today.subtract(Duration(days: i));
      final dayEnd = targetDay.add(Duration(days: 1));

      final dailyReadings = readings
          .where((r) => r.time.isAfter(targetDay) && r.time.isBefore(dayEnd))
          .toList();

      if (dailyReadings.isNotEmpty) {
        final avgGlucose =
            dailyReadings.map((r) => r.glucose).reduce((a, b) => a + b) /
            dailyReadings.length;

        grouped.add(
          Reading(
            glucose: avgGlucose,
            time: targetDay,
            xAxis: 6 - i, // 0=oldest, 6=today
            chartLabel: _getDayLabel(targetDay.weekday - 1),
          ),
        );
      }
    }

    return grouped;
  }

  List<Reading> _groupByWeek(List<Reading> readings, {int weeks = 8}) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final List<Reading> grouped = [];

    for (int i = weeks - 1; i >= 0; i--) {
      // Calculate the start of the week (Monday) for i weeks ago
      final targetWeekStart = today.subtract(Duration(days: i * 7));
      final daysFromMonday = (targetWeekStart.weekday - 1) % 7;
      final weekStart = targetWeekStart.subtract(
        Duration(days: daysFromMonday),
      );
      final weekEnd = weekStart.add(Duration(days: 7));

      final weeklyReadings = readings
          .where((r) => r.time.isAfter(weekStart) && r.time.isBefore(weekEnd))
          .toList();

      if (weeklyReadings.isNotEmpty) {
        final avgGlucose =
            weeklyReadings.map((r) => r.glucose).reduce((a, b) => a + b) /
            weeklyReadings.length;

        grouped.add(
          Reading(
            glucose: avgGlucose,
            time: weekStart,
            xAxis: weeks - 1 - i, // 0=oldest week, 7=current week
            chartLabel: _getWeekLabel(weekStart, i),
          ),
        );
      }
    }

    return grouped;
  }

  String _getDayLabel(int dayIndex) {
    const days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    return days[dayIndex];
  }

  String _getWeekLabel(DateTime weekStart, int weeksAgo) {
    if (weeksAgo == 0) {
      return "This week";
    } else if (weeksAgo == 1) {
      return "Last week";
    } else {
      return "${weekStart.month}/${weekStart.day}";
    }
  }
}
