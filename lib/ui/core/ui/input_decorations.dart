import 'package:flutter/material.dart';
import 'package:poupix/ui/core/themes/colors.dart';
import 'package:poupix/ui/core/themes/dimens.dart';

class AppInputDecorations {
  static InputDecoration normal({
    required String label,
    IconData? icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: label,
      labelText: label,
      labelStyle: const TextStyle(color: AppColors.black1),
      suffixIcon: suffix ?? (icon != null ? Icon(icon) : null),
      suffixIconColor: AppColors.grey3,
      errorStyle: const TextStyle(color: AppColors.red1),
      border: OutlineInputBorder(borderRadius: Dimens.borderRadius),
      enabledBorder: OutlineInputBorder(
        borderRadius: Dimens.borderRadius,
        borderSide: const BorderSide(color: AppColors.black1),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: Dimens.borderRadius,
        borderSide: BorderSide(color: AppColors.black1),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: Dimens.borderRadius,
        borderSide: BorderSide(color: AppColors.red1),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: Dimens.borderRadius,
        borderSide: BorderSide(color: AppColors.red1),
      ),
    );
  }

  static InputDecoration password({
    required String label,
    required bool isVisible,
    required VoidCallback onToggleVisibility,
  }) {
    return InputDecoration(
      hintText: label,
      labelText: label,
      labelStyle: const TextStyle(color: AppColors.black1),
      suffixIconColor: AppColors.grey3,
      suffixIcon: InkWell(
        onTap: onToggleVisibility,
        child: Icon(
          isVisible ? Icons.visibility_off : Icons.visibility,
        ),
      ),
      errorStyle: const TextStyle(color: AppColors.red1),
      border: OutlineInputBorder(borderRadius: Dimens.borderRadius),
      enabledBorder: OutlineInputBorder(
        borderRadius: Dimens.borderRadius,
        borderSide: const BorderSide(color: AppColors.black1),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: Dimens.borderRadius,
        borderSide: BorderSide(color: AppColors.black1),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: Dimens.borderRadius,
        borderSide: BorderSide(color: AppColors.red1),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: Dimens.borderRadius,
        borderSide: BorderSide(color: AppColors.red1),
      ),
    );
  }
}
