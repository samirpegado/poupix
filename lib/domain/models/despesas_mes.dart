import 'dart:convert';

import 'package:poupix/domain/models/despesa.dart';
import 'package:poupix/domain/models/total_categoria.dart';
import 'package:poupix/domain/models/total_tipo.dart';

class DespesasMesModel {
  final double total;
  final List<DespesaModel> despesas;
  final List<TotalCategoriaModel> totalCategoria;
  final List<TotalTipoModel> totalTipo;

  DespesasMesModel({
    required this.total,
    required this.despesas,
    required this.totalCategoria,
    required this.totalTipo,
  });

  factory DespesasMesModel.fromJson(Map<String, dynamic> json) {
    final despesasList = (json['despesas'] as List<dynamic>)
        .map((e) => DespesaModel.fromJson(e))
        .toList();

    final total = despesasList.fold<double>(
      0.0,
      (sum, item) => sum + item.valor,
    );
    return DespesasMesModel(
      total: total,
      despesas: despesasList,
      totalCategoria: (json['total_categoria'] as List<dynamic>)
          .map((e) => TotalCategoriaModel.fromJson(e))
          .toList(),
      totalTipo: (json['total_tipo'] as List<dynamic>)
          .map((e) => TotalTipoModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'total': total,
      'despesas': despesas.map((e) => e.toMap()).toList(),
      'total_categoria': totalCategoria.map((e) => e.toMap()).toList(),
      'total_tipo': totalTipo.map((e) => e.toMap()).toList(),
    };
  }

  String toJson() => jsonEncode(toMap());
}
