import 'package:flutter/material.dart';
import 'package:poupix/ui/core/themes/colors.dart';
import 'package:poupix/ui/core/themes/dimens.dart';
import 'package:poupix/ui/core/themes/theme.dart';

class ExpenseModalShell extends StatelessWidget {
  const ExpenseModalShell({
    super.key,
    required this.title,
    required this.child,
    this.maxHeight = 640,
  });

  final String title;
  final Widget child;
  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      constraints: BoxConstraints(
        maxWidth: 420,
        maxHeight: maxHeight,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 72,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: AppColors.black1,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Center(
              child: Text(
                title,
                style: AppTheme.lightTheme.textTheme.titleMedium
                    ?.copyWith(color: Colors.white),
              ),
            ),
          ),
          Flexible(
            child: Padding(
              padding: Dimens.of(context).edgeInsetsScreen,
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

Future<T?> showExpenseDialog<T>({
  required BuildContext context,
  required Widget child,
}) {
  return showDialog<T>(
    context: context,
    builder: (context) => Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: child,
    ),
  );
}
