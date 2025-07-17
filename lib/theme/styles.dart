import 'package:blood_glucose_monitor/theme/colors.dart';
import 'package:flutter/material.dart';

class AppButtonStylesLight {
  static final filled = TextButton.styleFrom(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.white,
    textStyle: TextStyle(
      fontFamily: "IBM Plex Sans",
      fontWeight: FontWeight.w600,
    ),
    padding: EdgeInsets.symmetric(horizontal: 24.0),
  );

  static final text = TextButton.styleFrom(
    backgroundColor: AppColors.white,
    foregroundColor: AppColors.black,
    textStyle: TextStyle(
      fontFamily: "IBM Plex Sans",
      fontWeight: FontWeight.w600,
      fontSize: 16.0,
    ),
    padding: EdgeInsets.symmetric(horizontal: 24.0),
  );
}
