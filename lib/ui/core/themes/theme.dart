import 'package:flutter/material.dart';
import 'colors.dart';

abstract final class AppTheme {
  static const btnTextStyleWhite = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const btnTextStyleBlack = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.black1,
  );

  static const _baseTextTheme = TextTheme(
    headlineLarge: TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.w700,
    ),
    headlineSmall: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w400,
    ),
    titleMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    titleSmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: AppColors.secondaryText,
    ),
    bodyLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w400,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: AppColors.secondaryText,
    ),
    labelSmall: TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      color: AppColors.grey3,
    ),
    labelMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.black1,
    ),
    labelLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: AppColors.black1,
    ),
  );

  static const _inputDecorationTheme = InputDecorationTheme(
    hintStyle: TextStyle(
      color: AppColors.grey3,
      fontSize: 18.0,
      fontWeight: FontWeight.w400,
    ),
  );

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: AppColors.lightColorScheme,
    textTheme: _baseTextTheme,
    inputDecorationTheme: _inputDecorationTheme,
    extensions: [],
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: AppColors.darkColorScheme,
    textTheme: _baseTextTheme,
    inputDecorationTheme: _inputDecorationTheme,
    extensions: [],
  );
}
