import 'package:flutter/material.dart';
import 'package:poupix/ui/core/themes/colors.dart';

class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
    this.compact = false,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final titleStyle = TextStyle(
      fontSize: compact ? 14 : 16,
      fontWeight: FontWeight.w600,
      color: AppColors.primaryText,
    );
    final subtitleStyle = TextStyle(
      fontSize: compact ? 12 : 13,
      color: AppColors.secondaryText,
    );

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: compact ? 12 : 32,
        horizontal: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: compact ? 36 : 56,
            color: AppColors.secondaryText.withValues(alpha: 0.7),
          ),
          SizedBox(height: compact ? 8 : 16),
          Text(title, textAlign: TextAlign.center, style: titleStyle),
          if (subtitle != null) ...[
            const SizedBox(height: 6),
            Text(subtitle!, textAlign: TextAlign.center, style: subtitleStyle),
          ],
          if (actionLabel != null && onAction != null) ...[
            SizedBox(height: compact ? 12 : 20),
            FilledButton(onPressed: onAction, child: Text(actionLabel!)),
          ],
        ],
      ),
    );
  }
}
