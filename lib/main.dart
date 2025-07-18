import 'package:blood_glucose_monitor/pages/onboarding.dart';
import 'package:blood_glucose_monitor/theme/theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blood Glucose Monitor',
      theme: AppTheme.light,
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: OnboardingPage(),
    );
  }
}
