import 'package:blood_glucose_monitor/services/auth_service.dart';
import 'package:blood_glucose_monitor/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileSettingsDialog extends StatelessWidget {
  const ProfileSettingsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Sign out?'),
      content: Text('Are you sure you want to sign out?'),
      actions: [
        TextButton(
          style: AppButtonStylesLight.text,
          onPressed: () async {
            Navigator.pop(context);
            await Provider.of<AuthService>(context, listen: false).signOut();
          },
          child: Text("Yes"),
        ),
        TextButton(
          style: AppButtonStylesLight.text,
          onPressed: () async {
            Navigator.pop(context);
          },
          child: Text("No"),
        ),
      ],
    );
  }
}
