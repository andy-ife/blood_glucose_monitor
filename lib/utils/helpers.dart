import 'package:flutter/material.dart';

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
