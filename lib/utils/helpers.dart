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
