import 'package:alarm/alarm.dart';
import 'package:blood_glucose_monitor/controllers/auth_controller.dart';
import 'package:blood_glucose_monitor/controllers/dashboard_controller.dart';
import 'package:blood_glucose_monitor/controllers/history_controller.dart';
import 'package:blood_glucose_monitor/controllers/reminders_controller.dart';
import 'package:blood_glucose_monitor/firebase_options.dart';
import 'package:blood_glucose_monitor/pages/auth/auth_gate.dart';
import 'package:blood_glucose_monitor/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Alarm.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthController>(create: (_) => AuthController()),
        ChangeNotifierProvider<RemindersController>(
          create: (_) => RemindersController(),
        ),
        ChangeNotifierProvider<DashboardController>(
          create: (_) => DashboardController(),
        ),
        ChangeNotifierProvider<HistoryController>(
          create: (_) => HistoryController(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blood Glucose Monitor',
      theme: AppTheme.light,
      themeMode: ThemeMode.light,
      home: AuthGate(),
    );
  }
}
