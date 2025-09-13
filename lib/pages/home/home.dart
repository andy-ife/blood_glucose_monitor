import 'package:blood_glucose_monitor/controllers/chat_controller.dart';
import 'package:blood_glucose_monitor/pages/home/chat.dart';
import 'package:blood_glucose_monitor/pages/home/dashboard.dart';
import 'package:blood_glucose_monitor/pages/home/history.dart';
import 'package:blood_glucose_monitor/pages/home/reminders.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final _chatFabIndexes = [0, 1];

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      floatingActionButton: _chatFabIndexes.contains(_selectedIndex)
          ? FloatingActionButton(
              heroTag: 'chat',
              foregroundColor: theme.colorScheme.onPrimary,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ChangeNotifierProvider(
                    create: (_) => ChatController(),
                    child: ChatPage(),
                  ),
                ),
              ),
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
            )
          : null,

      body: SafeArea(
        top: false,
        child: IndexedStack(
          index: _selectedIndex,
          children: [DashboardPage(), HistoryPage(), RemindersPage()],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: theme.colorScheme.surface,
        selectedIndex: _selectedIndex,
        onDestinationSelected: (newIndex) {
          setState(() {
            _selectedIndex = newIndex;
          });
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(
              Icons.home_rounded,
              color: theme.colorScheme.primary,
            ),
            label: "Dashboard",
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(
              Icons.bar_chart_rounded,
              color: theme.colorScheme.primary,
            ),
            label: "History",
          ),
          NavigationDestination(
            icon: Icon(Icons.alarm_outlined),
            selectedIcon: Icon(
              Icons.alarm_rounded,
              color: theme.colorScheme.primary,
            ),
            label: "Reminders",
          ),
        ],
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return theme.textTheme.labelMedium!.copyWith(
              color: theme.colorScheme.primary,
            );
          }
          return null;
        }),
      ),
    );
  }
}
