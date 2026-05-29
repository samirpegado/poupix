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
    color: AppColors.primaryText,
  );

  static const _baseTextTheme = TextTheme(
    headlineLarge: TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.w700,
      color: AppColors.primaryText,
    ),
    headlineSmall: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w400,
      color: AppColors.primaryText,
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
      color: AppColors.primaryText,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.primaryText,
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
      color: AppColors.primaryText,
    ),
    labelLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700,
      color: AppColors.primaryText,
    ),
  );

  static const _inputDecorationTheme = InputDecorationTheme(
    hintStyle: TextStyle(
      color: AppColors.grey3,
      fontSize: 18.0,
      fontWeight: FontWeight.w400,
    ),
  );

  static BoxDecoration cardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(14),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.06),
        blurRadius: 10,
        offset: const Offset(0, 2),
      ),
    ],
  );

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: AppColors.lightColorScheme,
    scaffoldBackgroundColor: AppColors.background,
    textTheme: _baseTextTheme,
    inputDecorationTheme: _inputDecorationTheme,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.black1,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.secondaryText,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
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
