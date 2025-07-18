import 'package:blood_glucose_monitor/theme/colors.dart';
import 'package:blood_glucose_monitor/theme/styles.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static final light = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary).copyWith(
      primary: AppColors.primary,
      primaryContainer: AppColors.primaryLight,
      primaryFixedDim: AppColors.primaryDark,
      onPrimary: AppColors.white,
      surface: AppColors.white,
      surfaceDim: AppColors.lightGrey,
      onSurface: AppColors.black,
      onSurfaceVariant: AppColors.darkGrey,
      outline: AppColors.outline,
    ),

    textTheme: TextTheme(
      displaySmall: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 20.0,
        fontWeight: FontWeight.w600,
        color: AppColors.white,
      ),
      displayLarge: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 28.0,
        color: AppColors.white,
      ),

      headlineMedium: TextStyle(
        fontFamily: 'IBM Plex Sans',
        fontSize: 28.0,
        color: AppColors.white,
      ),

      titleMedium: TextStyle(fontFamily: 'IBM Plex Sans', fontSize: 16.0),
      titleLarge: TextStyle(
        fontFamily: 'IBM Plex Sans',
        fontSize: 20.0,
        fontWeight: FontWeight.w600,
      ),

      bodyMedium: TextStyle(fontFamily: 'IBM Plex Sans', fontSize: 14.0),
      bodyLarge: TextStyle(
        fontFamily: 'IBM Plex Sans',
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
      ),

      labelMedium: TextStyle(fontFamily: 'IBM Plex Sans', fontSize: 12.0),

      labelSmall: TextStyle(
        fontFamily: "IBM Plex Sans",
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
        fontSize: 11.0,
      ),
    ),

    textButtonTheme: TextButtonThemeData(style: AppButtonStylesLight.filled),
  );
}
