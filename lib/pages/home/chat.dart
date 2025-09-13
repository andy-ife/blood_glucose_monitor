import 'dart:async';

import 'package:blood_glucose_monitor/models/message.dart';
import 'package:blood_glucose_monitor/utils/helpers.dart';
import 'package:blood_glucose_monitor/widgets/error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:blood_glucose_monitor/controllers/chat_controller.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late ChatController _chatController;

  @override
  void initState() {
    super.initState();
    _chatController = Provider.of<ChatController>(context, listen: false);

    _scrollController.addListener(_newMessageListener);
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.removeListener(_newMessageListener);
    _scrollController.dispose();
    super.dispose();
  }

  _newMessageListener() {
    _chatController.state.messageStream.listen((event) {
      Future.delayed(
        Duration(milliseconds: 200),
        () => _scrollController.jumpTo(
          _scrollController.position.maxScrollExtent,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 62.0,
        titleSpacing: 0.0,
        title: Row(
          spacing: 16.0,
          children: [
            CircleAvatar(radius: 24.0, child: Image.asset('assets/doc.png')),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Doc Leo'),
                Text(
                  'Online',
                  style: theme.textTheme.bodySmall!.copyWith(
                    color: Colors.green[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(child: _ChatBody(scrollController: _scrollController)),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 24.0),
                        hintText: 'Enter message',
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(28.0),
                        ),
                      ),
                      onSubmitted: (_) {
                        _chatController.sendMessage(_textController.text);
                        _textController.clear();
                      },
                    ),
                  ),
                  SizedBox(width: 8.0),
                  IconButton.filled(
                    padding: EdgeInsets.all(12.0),
                    onPressed: () {
                      if (_textController.text.isNotEmpty) {
                        HapticFeedback.vibrate();
                        _chatController.sendMessage(_textController.text);
                        _textController.clear();
                      }
                    },
                    icon: Icon(Icons.send_rounded),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatBody extends StatelessWidget {
  const _ChatBody({required this.scrollController});
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ChatController>();
    final state = controller.state;
    final theme = Theme.of(context);
    final constraints = MediaQuery.of(context).size;

    final page = state.isFetchingMessageStream
        ? Center(child: CircularProgressIndicator())
        : state.hasErrorFetchingMessageStream
        ? BGMErrorWidget(
            errorMessage: 'Error fetching messages.\n Are you online?',
            onRetry: () => controller.fetchMessageStream(),
          )
        : StreamBuilder(
            stream: state.messageStream,
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox.shrink();
              }
              if (snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text(
                    'I am here to serve you.\nWhat would you like to know today?',
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                final messages = snapshot.data!.docs
                    .map(
                      (doc) =>
                          Message.fromJson(doc.data() as Map<String, dynamic>),
                    )
                    .toList();
                return ListView.separated(
                  controller: scrollController,
                  padding: EdgeInsets.only(bottom: 40.0),
                  separatorBuilder: (_, __) => SizedBox(height: 4.0),
                  itemCount: messages.length,
                  itemBuilder: (ctx, i) {
                    final content = messages[i].message;
                    final timeString = timestampToString(messages[i].timestamp);
                    final isCurrUser =
                        state.currentUser.uid == messages[i].senderId;

                    return Align(
                      alignment: isCurrUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: constraints.width * 0.7,
                        ),
                        child: IntrinsicWidth(
                          child: Card(
                            elevation: isCurrUser ? 0.0 : 1.0,
                            color: isCurrUser
                                ? theme.colorScheme.primary
                                : theme.colorScheme.surface,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Wrap(
                                alignment: isCurrUser
                                    ? WrapAlignment.end
                                    : WrapAlignment.start,
                                runSpacing: 8.0,
                                children: [
                                  Text(
                                    content,
                                    style: isCurrUser
                                        ? theme.textTheme.titleMedium!.copyWith(
                                            color: Colors.white,
                                          )
                                        : theme.textTheme.titleMedium,
                                  ),
                                  Align(
                                    alignment: isCurrUser
                                        ? Alignment.centerRight
                                        : Alignment.centerLeft,
                                    child: Text(
                                      timeString,
                                      style: isCurrUser
                                          ? theme.textTheme.bodySmall!.copyWith(
                                              color: Color(0xfff0f0f0),
                                            )
                                          : theme.textTheme.bodySmall,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          );

    return page;
  }
}
