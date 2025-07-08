import 'package:flutter/material.dart';

abstract class AppColors {
  static const black1 = Color(0xFF282b36);
  static const secondaryText = Color(0xFF94a3b8);
  static const secondaryColor = Color(0xFF94a3b8);
  static const white1 = Color(0xFFFFF7FA);
  static const grey1 = Color(0xFFF2F2F2);
  static const grey2 = Color.fromARGB(255, 197, 197, 197);
  static const grey3 = Color.fromARGB(255, 216, 216, 216);
  static const alternate = Color(0xFFEDE7F6);
  static const whiteTransparent = Color(
    0x4DFFFFFF,
  ); // Figma rgba(255, 255, 255, 0.3)
  static const blackTransparent = Color(0x4D000000);
  static const red1 = Color(0xFFE74C3C);

  static const lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.black1,
    onPrimary: AppColors.white1,
    secondary: AppColors.black1,
    onSecondary: AppColors.white1,
    surface: Colors.white,
    onSurface: AppColors.black1,
    error: Colors.white,
    onError: Colors.red,
  );

  static const darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.white1,
    onPrimary: AppColors.black1,
    secondary: AppColors.white1,
    onSecondary: AppColors.black1,
    surface: AppColors.black1,
    onSurface: Colors.white,
    error: Colors.black,
    onError: AppColors.red1,
  );
}