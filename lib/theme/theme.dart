import 'package:blood_glucose_monitor/theme/colors.dart';
import 'package:blood_glucose_monitor/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  static final light = ThemeData(
    useMaterial3: true,
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
        fontWeight: FontWeight.w500,
        color: AppColors.white,
      ),
      displayLarge: TextStyle(
        fontFamily: 'Montserrat',
        fontSize: 28.0,
        color: AppColors.white,
      ),

      headlineLarge: TextStyle(
        fontFamily: 'IBM Plex Sans',
        fontSize: 36.0,
        color: AppColors.white,
        fontWeight: FontWeight.w500,
      ),

      headlineMedium: TextStyle(
        fontFamily: 'IBM Plex Sans',
        fontSize: 28.0,
        color: AppColors.white,
        fontWeight: FontWeight.w500,
      ),

      headlineSmall: TextStyle(
        fontFamily: 'IBM Plex Sans',
        fontSize: 22.0,
        color: AppColors.primary,
        fontWeight: FontWeight.w500,
      ),

      titleMedium: TextStyle(
        fontFamily: 'IBM Plex Sans',
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
      ),
      titleLarge: TextStyle(
        fontFamily: 'IBM Plex Sans',
        fontSize: 20.0,
        fontWeight: FontWeight.w500,
      ),

      bodyMedium: TextStyle(fontFamily: 'IBM Plex Sans', fontSize: 14.0),
      bodyLarge: TextStyle(fontFamily: 'IBM Plex Sans', fontSize: 16.0),
      bodySmall: TextStyle(fontFamily: 'IBM Plex Sans', fontSize: 12.0),

      labelMedium: TextStyle(fontFamily: 'IBM Plex Sans', fontSize: 12.0),

      labelSmall: TextStyle(
        fontFamily: "IBM Plex Sans",
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        fontSize: 11.0,
      ),
    ),

    textButtonTheme: TextButtonThemeData(style: AppButtonStylesLight.filled),

    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.white,
      scrolledUnderElevation: 0.0,
      systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: AppColors.white,
        systemNavigationBarDividerColor: AppColors.lightGrey,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    ),
  );
}
