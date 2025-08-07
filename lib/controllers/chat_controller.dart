import 'package:blood_glucose_monitor/models/message.dart';
import 'package:blood_glucose_monitor/utils/helpers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatController extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  ChatState state = ChatState(messageStream: Stream.empty());

  ChatController() {
    fetchMessageStream();
  }

  Future<void> fetchMessageStream() async {
    try {
      if (state.isFetchingMessageStream) return;

      state = state.copyWith(
        hasErrorFetchingMessageStream: false,
        isFetchingMessageStream: true,
      );
      notifyListeners();

      final chatRoomId = constructChatRoomId(
        senderId: _auth.currentUser!.uid,
        receiverId: 'doc_leo',
      );

      final stream = _firestore
          .collection('chatRooms')
          .doc(chatRoomId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .snapshots();

      state = state.copyWith(
        messageStream: stream,
        isFetchingMessageStream: false,
      );
      notifyListeners();
    } on Exception catch (e) {
      print(e.toString());
      state = state.copyWith(
        hasErrorFetchingMessageStream: true,
        errorMessage: e.toString(),
        isFetchingMessageStream: false,
      );
      notifyListeners();
      // give snackbar time to display
      await Future.delayed(Duration(milliseconds: 50));
    }
  }

  Future<void> sendMessage(String message) async {
    try {
      final newMessage = Message(
        senderId: _auth.currentUser!.uid,
        senderEmail: _auth.currentUser!.email!,
        receiverId: 'doc_leo', // patients can only chat with Doc Leo
        message: message,
        timestamp: Timestamp.now(),
        isRead: false,
      );

      state = state.copyWith(isSending: true);
      notifyListeners();

      final chatRoomId = constructChatRoomId(
        senderId: _auth.currentUser!.uid,
        receiverId: 'doc_leo',
      );

      await _firestore
          .collection('chatRooms')
          .doc(chatRoomId)
          .collection('messages')
          .add(newMessage.toJson()); // add new message to stream

      state = state.copyWith(isSending: false);
      notifyListeners();
    } on Exception catch (e) {
      print(e.toString());
      state = state.copyWith(
        hasErrorSendingMessage: true,
        errorMessage: e.toString(),
        isSending: false,
      );
      notifyListeners();
      // give snackbar time to display
      await Future.delayed(Duration(milliseconds: 50));
    } finally {
      state = state.copyWith(hasErrorSendingMessage: false, isSending: false);
      notifyListeners();
    }
  }
}

class ChatState {
  final Stream<QuerySnapshot> messageStream;
  final bool hasErrorSendingMessage;
  final bool isSending;
  final bool hasErrorFetchingMessageStream;
  final bool isFetchingMessageStream;
  final String errorMessage;
  final bool hasNewMessage;

  const ChatState({
    required this.messageStream,
    this.hasErrorSendingMessage = false,
    this.isSending = false,
    this.hasErrorFetchingMessageStream = false,
    this.isFetchingMessageStream = false,
    this.errorMessage = '',
    this.hasNewMessage = false,
  });

  ChatState copyWith({
    Stream<QuerySnapshot>? messageStream,
    bool? hasErrorSendingMessage,
    bool? isSending,
    bool? hasErrorFetchingMessageStream,
    bool? isFetchingMessageStream,
    String? errorMessage,
    bool? hasNewMessage,
  }) {
    return ChatState(
      messageStream: messageStream ?? this.messageStream,
      hasErrorSendingMessage:
          hasErrorSendingMessage ?? this.hasErrorSendingMessage,
      isSending: isSending ?? this.isSending,
      hasErrorFetchingMessageStream:
          hasErrorFetchingMessageStream ?? this.hasErrorFetchingMessageStream,
      isFetchingMessageStream:
          isFetchingMessageStream ?? this.isFetchingMessageStream,
      errorMessage: errorMessage ?? this.errorMessage,
      hasNewMessage: hasNewMessage ?? this.hasNewMessage,
    );
  }
}
