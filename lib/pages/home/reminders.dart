import 'dart:math';

import 'package:blood_glucose_monitor/controllers/reminders_controller.dart';
import 'package:blood_glucose_monitor/models/reminder.dart';
import 'package:blood_glucose_monitor/utils/helpers.dart';
import 'package:blood_glucose_monitor/widgets/add_reminder.dart';
import 'package:blood_glucose_monitor/widgets/error_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class RemindersPage extends StatelessWidget {
  const RemindersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = context.watch<RemindersController>();
    final state = controller.state;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: 'reminder',
        foregroundColor: theme.colorScheme.onPrimary,
        onPressed: () => showDialog(
          context: context,
          builder: (ctx) => AddReminderDialog(
            onContinue: (description, time) async {
              await Provider.of<RemindersController>(
                context,
                listen: false,
              ).addReminder(
                Reminder(
                  id: Random().nextInt(1000000),
                  userId: FirebaseAuth.instance.currentUser!.uid,
                  description: description,
                  time: time,
                ),
              );
            },
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add),
            Text(
              'New',
              style: theme.textTheme.labelMedium!.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(title: Text('Reminders')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16.0,
          children: [
            Text(
              'All',
              style: theme.textTheme.titleMedium!.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            state.isFetchingReminders
                ? Center(child: CircularProgressIndicator())
                : state.hasErrorFetchingReminders
                ? BGMErrorWidget(
                    errorMessage: 'Error fetching messages.\n Are you online?',
                    onRetry: () => controller.fetchRemindersStream(),
                  )
                : StreamBuilder(
                    stream: state.remindersStream,
                    builder: (ctx, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return SizedBox.shrink();
                      }
                      if (snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Text(
                            'No reminders added',
                            textAlign: TextAlign.center,
                          ),
                        );
                      } else {
                        final reminders = snapshot.data!.docs
                            .map(
                              (doc) => Reminder.fromJson(
                                doc.data() as Map<String, dynamic>,
                              ),
                            )
                            .toList();
                        reminders.sort((a, b) => b.time!.compareTo(a.time!));
                        return Expanded(
                          child: ListView.separated(
                            padding: EdgeInsets.only(bottom: 40.0),
                            separatorBuilder: (_, __) => SizedBox(height: 4.0),
                            itemCount: reminders.length,
                            itemBuilder: (ctx, i) {
                              return Card(
                                child: ListTile(
                                  leading: SvgPicture.asset(
                                    'assets/glucometer.svg',
                                  ),
                                  trailing: GestureDetector(
                                    onTap: () => showDialog(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        content: Text('Delete this reminder?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () async {
                                              Navigator.pop(context);
                                              await controller.deleteReminder(
                                                reminders[i].id,
                                              );
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
                                      ),
                                    ),
                                    child: Icon(Icons.delete_outline),
                                  ),
                                  title: Text(reminders[i].description),
                                  subtitle: Text(
                                    formatDateTimeToReadable(
                                      reminders[i].time!,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
