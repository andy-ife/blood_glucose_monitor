import 'package:blood_glucose_monitor/constants/glucose_level.dart';
import 'package:blood_glucose_monitor/models/reading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

bool isDarkMode(ThemeData theme) {
  return theme.brightness == Brightness.dark;
}

// Build a chatroom ID by sorting and joining sender and receiver IDs
String constructChatRoomId({
  required String senderId,
  required String receiverId,
}) {
  List<String> ids = [senderId, receiverId];
  ids.sort(); // sort so the order is always the same
  return ids.join('_');
}

String timestampToString(Timestamp timestamp, {String? timezone}) {
  DateTime dateTime = timestamp.toDate();

  if (timezone == 'local') {
    dateTime = dateTime.toLocal();
  }

  DateFormat formatter = DateFormat('MMM d HH:mm');
  return formatter.format(dateTime);
}

String formatDateTimeToReadable(DateTime date) {
  final months = [
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
  final month = months[date.month - 1];
  final day = date.day;
  final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
  final minute = date.minute.toString().padLeft(2, '0');
  final ampm = date.hour >= 12 ? 'pm' : 'am';

  // Get ordinal suffix
  String suffix;
  if (day >= 11 && day <= 13) {
    suffix = 'th';
  } else {
    switch (day % 10) {
      case 1:
        suffix = 'st';
        break;
      case 2:
        suffix = 'nd';
        break;
      case 3:
        suffix = 'rd';
        break;
      default:
        suffix = 'th';
    }
  }

  return '$month $day$suffix  $hour:$minute$ampm';
}

GlucoseLevel getGlucoseLevel(double reading) {
  GlucoseLevel level;

  if (reading < 70) {
    level = GlucoseLevel.low;
  } else if (reading >= 70 && reading < 100) {
    level = GlucoseLevel.good;
  } else if (reading >= 100 && reading < 126) {
    level = GlucoseLevel.ok;
  } else {
    level = GlucoseLevel.high;
  }
  return level;
}

extension StringCasingExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}

double getAverageGlucose(List<Reading> readings) {
  final sum = readings.map((e) => e.glucose).reduce((a, b) => a + b);
  return sum / readings.length;
}

double getHighestGlucose(List<Reading> readings) {
  return readings.map((e) => e.glucose).reduce((a, b) => a < b ? a : b);
}

double getLowestGlucose(List<Reading> readings) {
  return readings.map((e) => e.glucose).reduce((a, b) => a > b ? a : b);
}
