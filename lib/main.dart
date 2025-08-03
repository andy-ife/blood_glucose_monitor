import 'package:blood_glucose_monitor/firebase_options.dart';
import 'package:blood_glucose_monitor/pages/onboarding.dart';
import 'package:blood_glucose_monitor/theme/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blood Glucose Monitor',
      theme: AppTheme.light,
      themeMode: ThemeMode.light,
      home: OnboardingPage(),
    );
  }
}
