import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:poupix/app_state/app_state.dart';
import 'package:poupix/data/repositories/despesas_repository.dart';
import 'package:poupix/domain/models/despesa.dart';
import 'package:poupix/domain/models/despesas_mes.dart';
import 'package:poupix/utils/command.dart';
import 'package:poupix/utils/result.dart';

class ExpensesViewModel {
  ExpensesViewModel({required this.appState}) {
    fetchDespesas = Command0<DespesasMesModel>(_buscarDespesas);
    fetchDespesas.execute(); // executa automaticamente ao instanciar
  }

  final AppState appState;
  final _logger = Logger('ExpensesViewModel');
  final despesasRepository = DespesasRepository();
  late final Command0<DespesasMesModel> fetchDespesas;

  String? categoriaSelecionada;

  /// Retorna todas as despesas do mês selecionado
  List<DespesaModel> get despesas =>
      appState.despesasMes?.despesas ?? [];

  /// Retorna lista de categorias únicas + "Todas"
  List<String> get categorias =>
      ['Todas'] + despesas.map((d) => d.categoriaTitulo).toSet().toList();

  /// Retorna lista de despesas filtradas pela categoria (ou todas)
  List<DespesaModel> get despesasFiltradas {
    if (categoriaSelecionada == null || categoriaSelecionada == 'Todas') {
      return despesas;
    }
    return despesas
        .where((d) => d.categoriaTitulo == categoriaSelecionada)
        .toList();
  }

  /// Soma o total das despesas filtradas
  double get total => despesasFiltradas.fold(0.0, (sum, item) => sum + item.valor);

  /// Atualiza a categoria e refaz o filtro
  void selecionarCategoria(String? novaCategoria) {
    categoriaSelecionada = novaCategoria;
  }

  Future<Result<DespesasMesModel>> _buscarDespesas() async {
    try {
      final userId = appState.usuario?.id;
      if (userId == null) {
        return Result.error(Exception('Usuário não está logado'));
      }

      if (appState.overrideCache == true) {
        categoriaSelecionada = null;
        final model = await despesasRepository.buscarDespesasMes(
          userId: userId,
          pData: DateFormat('yyyy-MM-dd')
              .format(appState.dataSelecionada ?? DateTime.now()),
        );
        appState.salvarDespesasMes(model);
        return Result.ok(model);
      } else {
        final cached = appState.despesasMes;
        return cached == null
            ? Result.error(Exception('Cache vazio'))
            : Result.ok(cached);
      }
    } catch (e) {
      _logger.severe('Erro ao buscar despesas: $e');
      return Result.error(Exception('Erro ao buscar despesas'));
    }
  }
}
