import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:poupix/ui/core/themes/colors.dart';

class ExpenseToolbar extends StatelessWidget {
  const ExpenseToolbar({
    super.key,
    required this.mesReferencia,
    required this.onMonthTap,
    required this.onFiltersTap,
    required this.onExportTap,
    this.filtersActive = false,
  });

  final DateTime mesReferencia;
  final VoidCallback onMonthTap;
  final VoidCallback onFiltersTap;
  final VoidCallback onExportTap;
  final bool filtersActive;

  @override
  Widget build(BuildContext context) {
    final mesLabel =
        DateFormat('LLL y', 'pt_BR').format(mesReferencia);

    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onMonthTap,
            icon: const Icon(Icons.calendar_today, size: 18),
            label: Text(
              mesLabel[0].toUpperCase() + mesLabel.substring(1),
              overflow: TextOverflow.ellipsis,
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primaryText,
              side: const BorderSide(color: AppColors.grey2),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ),
        ),
        const SizedBox(width: 8),
        _ToolbarIconButton(
          icon: Icons.filter_list,
          tooltip: 'Filtros',
          onTap: onFiltersTap,
          showBadge: filtersActive,
        ),
        _ToolbarIconButton(
          icon: Icons.picture_as_pdf_outlined,
          tooltip: 'Exportar PDF',
          onTap: onExportTap,
        ),
      ],
    );
  }
}

class _ToolbarIconButton extends StatelessWidget {
  const _ToolbarIconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.showBadge = false,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final bool showBadge;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Badge(
        isLabelVisible: showBadge,
        smallSize: 8,
        child: IconButton.filledTonal(
          onPressed: onTap,
          tooltip: tooltip,
          icon: Icon(icon, size: 20),
          style: IconButton.styleFrom(
            backgroundColor: AppColors.grey1,
            foregroundColor: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
