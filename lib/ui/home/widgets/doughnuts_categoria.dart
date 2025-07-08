import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:poupix/domain/models/total_categoria.dart';
import 'package:poupix/utils/functions.dart';

class DoughnutsTotalCategoria extends StatefulWidget {
  const DoughnutsTotalCategoria({
    super.key,
    this.width,
    this.height,
    required this.totalCategorias,
  });

  final double? width;
  final double? height;
  final List<TotalCategoriaModel> totalCategorias;

  @override
  State<DoughnutsTotalCategoria> createState() =>
      _DoughnutsTotalCategoriaState();
}

class _DoughnutsTotalCategoriaState extends State<DoughnutsTotalCategoria> {
  final List<Color> vividColors = [
    Colors.redAccent,
    Colors.blueAccent,
    Colors.greenAccent,
    Colors.orangeAccent,
    Colors.purpleAccent,
  ];

  

  @override
  Widget build(BuildContext context) {
    final topCategorias = widget.totalCategorias
        .where((e) => e.valor > 0)
        .toList()
      ..sort((a, b) => b.valor.compareTo(a.valor));

    final top5 = topCategorias.take(5).toList();

    final total = top5.fold<double>(0.0, (sum, item) => sum + item.valor);

    return widget.totalCategorias.isEmpty? Center(child: Text('Nenhum dado a ser exibido'),) : Column(
      children: [
        SizedBox(
          width: 250,
          height: 250,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              sections: top5.asMap().entries.map((entry) {
                final index = entry.key;
                final data = entry.value;
                final percent = (data.valor / total) * 100;

                return PieChartSectionData(
                  color: vividColors[index],
                  value: data.valor,
                  title: '${percent.toStringAsFixed(1)}%',
                  radius: 80,
                  titleStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: top5.asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: vividColors[index],
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${item.nomeCategoria}: ${currencyFormat.format(item.valor)}',
                    style: const TextStyle(fontSize: 13),
                  ),
                ],
              ),
            );
          }).toList(),
        )
      ],
    );
  }
}