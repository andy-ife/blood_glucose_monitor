import 'package:flutter/material.dart';

class RemindersPage extends StatelessWidget {
  const RemindersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Reminders',
        style: Theme.of(
          context,
        ).textTheme.displayLarge!.copyWith(color: Colors.indigo),
      ),
    );
  }
}
