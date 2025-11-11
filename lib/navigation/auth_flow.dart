import 'package:blood_glucose_monitor/navigation/routes.dart';
import 'package:blood_glucose_monitor/pages/auth/account_details.dart';
import 'package:blood_glucose_monitor/pages/auth/onboarding.dart';
import 'package:blood_glucose_monitor/pages/auth/signin.dart';
import 'package:blood_glucose_monitor/pages/auth/signup.dart';
import 'package:flutter/material.dart';

class AuthFlow extends StatelessWidget {
  final _navigatorKey = GlobalKey<NavigatorState>();

  AuthFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: _navigatorKey,
      initialRoute: Routes.onboarding,
      onGenerateRoute: (settings) {
        Widget page;
        if (settings.name == Routes.accountDetails) {
          page = AccountDetailsForm(email: settings.arguments as String);
        } else if (settings.name == Routes.signUp) {
          page = SignUpForm();
        } else if (settings.name == Routes.signIn) {
          page = SignInForm();
        } else {
          page = OnboardingPage();
        }
        return MaterialPageRoute(builder: (_) => page, settings: settings);
      },
    );
  }
}
