import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String senderEmail;
  final String receiverId;
  final String message;
  final Timestamp timestamp;
  final bool isRead;

  const Message({
    this.senderId = '000',
    this.senderEmail = '_glucoseboy@gmail.com',
    this.receiverId = '001',
    this.message = 'May you always be in good health',
    required this.timestamp,
    this.isRead = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'senderEmail': senderEmail,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
      'isRead': isRead,
    };
  }

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      senderId: json['senderId'] ?? "",
      senderEmail: json['senderEmail'] ?? "",
      receiverId: json['receiverId'] ?? "",
      message: json['message'] ?? "no message",
      timestamp: json['timestamp'] ?? Timestamp.now(),
      isRead: json['isRead'] ?? false,
    );
  }
}
