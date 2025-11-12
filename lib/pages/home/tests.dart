import 'package:blood_glucose_monitor/controllers/dashboard_controller.dart';
import 'package:blood_glucose_monitor/navigation/routes.dart';
import 'package:blood_glucose_monitor/widgets/button_group.dart';
import 'package:blood_glucose_monitor/widgets/recent_test_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TestsPage extends StatefulWidget {
  const TestsPage({super.key});

  @override
  State<TestsPage> createState() => _TestsPageState();
}

class _TestsPageState extends State<TestsPage> {
  String _selectedPeriod = "Today";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = context.watch<DashboardController>().state;

    final readings = _selectedPeriod == "Today"
        ? state.todayTests
        : _selectedPeriod == "Last 7 Days"
        ? state.weeklyTests
        : _selectedPeriod == "Last Month"
        ? state.monthlyTests
        : state.allTests;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        foregroundColor: theme.colorScheme.onPrimary,
        onPressed: () => Navigator.of(context).pushNamed(Routes.chat),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_bubble_outline),
            Text(
              'Chat',
              style: theme.textTheme.labelMedium!.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(title: const Text('Your Tests')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Button Group Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: BGMButtonGroup(
                values: const ['Today', 'Last 7 Days', 'Last Month', 'All'],
                onSelectionChange: (selectedValues) {
                  setState(() => _selectedPeriod = selectedValues.first);
                },
                enableMultiSelection: false,
                initialSelection: {'Today'},
              ),
            ),

            if (_selectedPeriod != "All")
              Row(
                children: [
                  Padding(
                    padding: EdgeInsetsGeometry.symmetric(
                      vertical: 10,
                      horizontal: 16,
                    ),
                    child: Text(
                      "Note that these are the average of your readings",
                      style: theme.textTheme.bodyMedium!.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),

            ...[
              for (var reading in readings)
                Padding(
                  padding: EdgeInsetsGeometry.symmetric(
                    horizontal: 16.0,
                    vertical: 2.0,
                  ),
                  child: RecentTestCard(
                    reading: reading,
                    showTime: _selectedPeriod == "All",
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
