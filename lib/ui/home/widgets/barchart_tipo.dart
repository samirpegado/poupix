import 'package:flutter/material.dart';
import 'package:poupix/domain/models/total_tipo.dart';
import 'package:poupix/ui/core/themes/theme.dart';
import 'package:poupix/utils/functions.dart';

class SimpleHorizontalBarChart extends StatelessWidget {
  const SimpleHorizontalBarChart({
    super.key,
    required this.totalTipo,
  });

  final List<TotalTipoModel> totalTipo;

  Color getBarColor(String tipo) {
    switch (tipo.toLowerCase()) {
      case 'fixa':
        return Colors.blueAccent;
      case 'parcelada':
        return Colors.orangeAccent;
      case 'única':
        return Colors.purpleAccent;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final maxValor = totalTipo.isNotEmpty
        ? totalTipo.map((e) => e.valor).reduce((a, b) => a > b ? a : b)
        : 1;

    return totalTipo.isEmpty? Center(child: Text('Nenhum dado a ser exibido'),) : Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: totalTipo.map((item) {
        final percentual = item.valor / maxValor;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 80,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.nomeTipo,
                      style: const TextStyle(fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      currencyFormat.format(item.valor),
                      style: AppTheme.lightTheme.textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: percentual,
                      child: Container(
                        height: 20,
                        decoration: BoxDecoration(
                          color: getBarColor(item.nomeTipo),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
