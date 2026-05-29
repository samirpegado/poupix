import 'package:flutter/material.dart';
import 'package:poupix/ui/core/themes/colors.dart';

void showSuccessSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: AppColors.black1,
    ),
  );
}

void showErrorSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: AppColors.red1,
    ),
  );
}

String errorMessage(Object error) {
  final text = error.toString();
  if (text.startsWith('Exception: ')) {
    return text.replaceFirst('Exception: ', '');
  }
  return 'Ocorreu um erro. Tente novamente.';
}
