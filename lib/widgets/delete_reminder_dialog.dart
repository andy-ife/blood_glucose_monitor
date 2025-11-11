import 'package:blood_glucose_monitor/controllers/reminders_controller.dart';
import 'package:blood_glucose_monitor/models/reminder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeleteReminderDialog extends StatelessWidget {
  const DeleteReminderDialog({super.key, required this.reminder});

  final Reminder reminder;

  @override
  Widget build(BuildContext context) {
    final controller = context.read<RemindersController>();
    return AlertDialog(
      content: Text('Delete this reminder?'),
      actions: [
        TextButton(
          onPressed: () async {
            Navigator.pop(context);
            await controller.deleteReminder(reminder.id);
          },
          child: Text('Yes'),
        ),
        TextButton(
          onPressed: () async {
            Navigator.pop(context);
          },
          child: Text('No'),
        ),
      ],
    );
  }
}
