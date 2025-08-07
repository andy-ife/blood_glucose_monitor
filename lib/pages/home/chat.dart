import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

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
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        'I am here to serve you.\nWhat would you like to know today?',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 24.0),
                      hintText: 'Enter message',
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(28.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                IconButton.filled(
                  padding: EdgeInsets.all(12.0),
                  onPressed: () {},
                  icon: Icon(Icons.send_rounded),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
