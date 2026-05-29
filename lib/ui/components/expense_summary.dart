import 'package:flutter/material.dart';
import 'package:poupix/ui/core/themes/colors.dart';
import 'package:poupix/ui/core/themes/theme.dart';
import 'package:poupix/utils/functions.dart';

class ExpenseSummary extends StatelessWidget {
  const ExpenseSummary({
    super.key,
    required this.total,
    required this.totalLiquidado,
    required this.totalPendente,
  });

  final double total;
  final double totalLiquidado;
  final double totalPendente;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.grey1,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          _SummaryRow(
            label: 'Total',
            value: total,
            emphasized: true,
          ),
          const SizedBox(height: 8),
          _SummaryRow(
            label: 'Liquidado',
            value: totalLiquidado,
            color: Colors.green.shade700,
          ),
          const SizedBox(height: 4),
          _SummaryRow(
            label: 'Pendente',
            value: totalPendente,
            color: AppColors.red1,
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.emphasized = false,
    this.color,
  });

  final String label;
  final double value;
  final bool emphasized;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final style = emphasized
        ? AppTheme.lightTheme.textTheme.labelLarge
        : AppTheme.lightTheme.textTheme.bodyMedium;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(
          currencyFormat.format(value),
          style: style?.copyWith(color: color),
        ),
      ],
    );
  }
}
