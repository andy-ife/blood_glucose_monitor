import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RemindersPage extends StatelessWidget {
  const RemindersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        heroTag: null,
        foregroundColor: theme.colorScheme.onPrimary,
        onPressed: () {},
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16.0,
            children: [
              Text(
                'Active',
                style: theme.textTheme.titleMedium!.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              ...List.generate(
                3,
                (i) => Card(
                  child: ListTile(
                    leading: SvgPicture.asset('assets/glucometer.svg'),
                    trailing: Icon(Icons.delete_outline),
                    title: Text('Take Blood Test'),
                    subtitle: Text('Jan 5th  11:00pm'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
