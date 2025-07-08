import 'package:flutter/material.dart';
import 'package:poupix/domain/models/despesa.dart';
import 'package:poupix/ui/core/themes/colors.dart';
import 'package:poupix/ui/core/themes/theme.dart';
import 'package:poupix/utils/functions.dart';

class ExpenseItem extends StatelessWidget {
  final DespesaModel despesa;
  const ExpenseItem({super.key, required this.despesa});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisSize: MainAxisSize.max, children: [
      Icon(
        Icons.monetization_on_outlined,
        color: AppColors.secondaryText,
        size: 24,
      ),
      SizedBox(width: 8,),
      Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectionArea(
                child: Text(despesa.titulo,
                    style: AppTheme.lightTheme.textTheme.labelMedium)),
            Row(mainAxisSize: MainAxisSize.max, children: [
              Text(
                despesa.categoriaTitulo,
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
              if (despesa.tipo == 'Parcelada')
                Text(
                  ' (${despesa.parcelaAtual ?? 0}/${despesa.parcelas ?? 0})',
                  style: AppTheme.lightTheme.textTheme.bodySmall,
                ),
            ]),
            Row(mainAxisSize: MainAxisSize.max, children: [
              Text(
                'Dia ${despesa.vencimento.substring(8, 10)}',
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
            ])
          ],
        ),
      ),
      Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(currencyFormat.format(despesa.valor)),
          Icon(
            Icons.arrow_right,
            color: AppColors.secondaryColor,
            size: 20,
          ),
        ],
      ),
    ]);
  }
}
