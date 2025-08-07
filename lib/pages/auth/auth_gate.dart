import 'package:blood_glucose_monitor/pages/home/home.dart';
import 'package:blood_glucose_monitor/pages/auth/onboarding.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            return HomePage();
          } else {
            return OnboardingPage();
          }
        },
      ),
    );
  }
}
