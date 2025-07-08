import 'package:intl/intl.dart';
import 'package:poupix/domain/models/despesa.dart';

final NumberFormat currencyFormat =
    NumberFormat.simpleCurrency(locale: 'pt_BR');

List<DespesaModel> filtroDespesas(
  List<DespesaModel> lista,
  String? categoria,
) {
  // Se a lista for vazia ou ambos os filtros forem nulos/vazios, retorna a lista original
  if (lista.isEmpty || (categoria == null || categoria.isEmpty || categoria == 'Todas')) {
    return lista;
  }

  return lista.where((despesa) {
    // Comparação de categoria
    final matchCategoria = (categoria.isEmpty)
        ? true
        : (despesa.categoriaTitulo.toLowerCase() == categoria.toLowerCase());

    return matchCategoria;
  }).toList();
}
