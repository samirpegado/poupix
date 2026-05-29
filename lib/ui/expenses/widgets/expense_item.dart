import 'package:flutter/material.dart';
import 'package:poupix/domain/models/despesa.dart';
import 'package:poupix/ui/core/themes/colors.dart';
import 'package:poupix/ui/core/themes/theme.dart';
import 'package:poupix/utils/functions.dart';

class ExpenseItem extends StatelessWidget {
  const ExpenseItem({
    super.key,
    required this.despesa,
    this.onTap,
    this.onToggleLiquidada,
  });

  final DespesaModel despesa;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onToggleLiquidada;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.grey1,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Checkbox(
                value: despesa.liquidada,
                onChanged: onToggleLiquidada == null
                    ? null
                    : (value) => onToggleLiquidada!(value ?? false),
                activeColor: Colors.green.shade700,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      despesa.titulo,
                      style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                        decoration: despesa.liquidada
                            ? TextDecoration.lineThrough
                            : null,
                        color: despesa.liquidada
                            ? AppColors.secondaryText
                            : null,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          despesa.categoriaTitulo,
                          style: AppTheme.lightTheme.textTheme.bodySmall,
                        ),
                        if (despesa.tipo == 'Parcelada')
                          Text(
                            ' (${despesa.parcelaAtual ?? 0}/${despesa.parcelas ?? 0})',
                            style: AppTheme.lightTheme.textTheme.bodySmall,
                          ),
                        if (despesa.tipo == 'Fixa')
                          Text(
                            ' · Recorrente',
                            style: AppTheme.lightTheme.textTheme.bodySmall,
                          ),
                      ],
                    ),
                    Text(
                      'Venc. ${despesa.vencimento.substring(8, 10)}/${despesa.vencimento.substring(5, 7)}',
                      style: AppTheme.lightTheme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Text(
                currencyFormat.format(despesa.valor),
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  decoration:
                      despesa.liquidada ? TextDecoration.lineThrough : null,
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: AppColors.secondaryColor,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
