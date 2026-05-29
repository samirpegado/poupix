import 'package:flutter/material.dart';

abstract class AppColors {
  /// Verde escuro — cabeçalhos, AppBar, navbar selecionada
  static const black1 = Color(0xFF065F46);

  static const primaryText = Color(0xFF1E293B);
  static const primary = Color(0xFF059669);
  static const secondaryText = Color(0xFF64748B);
  static const secondaryColor = Color(0xFF94A3B8);
  static const white1 = Color(0xFFFFFFFF);
  static const background = Color(0xFFF8FAFC);
  static const grey1 = Color(0xFFF1F5F9);
  static const grey2 = Color.fromARGB(255, 197, 197, 197);
  static const grey3 = Color.fromARGB(255, 216, 216, 216);
  static const alternate = Color(0xFFD1FAE5);
  static const whiteTransparent = Color(0x4DFFFFFF);
  static const blackTransparent = Color(0x4D000000);
  static const red1 = Color(0xFFDC2626);
  static const success = Color(0xFF16A34A);
  static const pending = Color(0xFFD97706);

  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: AppColors.white1,
    secondary: AppColors.black1,
    onSecondary: AppColors.white1,
    surface: Colors.white,
    onSurface: AppColors.primaryText,
    error: AppColors.red1,
    onError: Colors.white,
  );

  static const darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.primary,
    onPrimary: AppColors.black1,
    secondary: AppColors.white1,
    onSecondary: AppColors.black1,
    surface: AppColors.black1,
    onSurface: Colors.white,
    error: AppColors.red1,
    onError: Colors.white,
  );
}
