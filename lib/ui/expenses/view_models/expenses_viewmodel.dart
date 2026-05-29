import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:poupix/app_state/app_state.dart';
import 'package:poupix/data/repositories/despesas_repository.dart';
import 'package:poupix/domain/models/despesa.dart';
import 'package:poupix/domain/models/despesas_mes.dart';
import 'package:poupix/ui/expenses/widgets/expense_filters_sheet.dart';
import 'package:poupix/utils/command.dart';
import 'package:poupix/utils/result.dart';

class ExpensesViewModel {
  ExpensesViewModel({required this.appState}) {
    fetchDespesas = Command0<DespesasMesModel>(_buscarDespesas);
    fetchDespesas.execute();
  }

  final AppState appState;
  final _logger = Logger('ExpensesViewModel');
  final despesasRepository = DespesasRepository();
  late final Command0<DespesasMesModel> fetchDespesas;

  String? categoriaSelecionada;
  String? filtroLiquidada;

  List<DespesaModel> get despesas => appState.despesasMes?.despesas ?? [];

  List<String> get categorias =>
      ['Todas', ...despesas.map((d) => d.categoriaTitulo).toSet()];

  ExpenseFilters get filtrosAtivos => ExpenseFilters(
        categoria: categoriaSelecionada,
        situacao: filtroLiquidada,
      );

  bool get temFiltrosAtivos => filtrosAtivos.hasActiveFilters;

  List<DespesaModel> get _baseFiltrada {
    var lista = despesas;

    if (categoriaSelecionada != null && categoriaSelecionada != 'Todas') {
      lista = lista
          .where((d) => d.categoriaTitulo == categoriaSelecionada)
          .toList();
    }

    if (filtroLiquidada == 'Liquidadas') {
      lista = lista.where((d) => d.liquidada).toList();
    } else if (filtroLiquidada == 'Pendentes') {
      lista = lista.where((d) => !d.liquidada).toList();
    }

    return lista;
  }

  List<DespesaModel> get despesasFiltradas => _baseFiltrada;

  double get total => _baseFiltrada.fold(0.0, (sum, item) => sum + item.valor);

  double get totalLiquidado => _baseFiltrada
      .where((d) => d.liquidada)
      .fold(0.0, (sum, item) => sum + item.valor);

  double get totalPendente => _baseFiltrada
      .where((d) => !d.liquidada)
      .fold(0.0, (sum, item) => sum + item.valor);

  void aplicarFiltros(ExpenseFilters filtros) {
    categoriaSelecionada = filtros.categoria;
    filtroLiquidada = filtros.situacao;
  }

  void limparFiltros() {
    categoriaSelecionada = null;
    filtroLiquidada = null;
  }

  Future<Result<void>> alternarLiquidada(DespesaModel despesa) async {
    try {
      await despesasRepository.atualizarLiquidada(
        despesaId: despesa.despesaId,
        liquidada: !despesa.liquidada,
        tipo: despesa.tipo,
        userId: appState.usuario!.id,
        mesReferencia: appState.dataSelecionada ?? DateTime.now(),
      );
      await appState.limparCacheDespesas();
      await fetchDespesas.execute();
      return Result.ok(null);
    } catch (e) {
      _logger.severe('Erro ao atualizar liquidada: $e');
      return Result.error(Exception('Não foi possível atualizar a despesa.'));
    }
  }

  Future<Result<DespesasMesModel>> _buscarDespesas() async {
    try {
      final userId = appState.usuario?.id;
      if (userId == null) {
        return Result.error(Exception('Usuário não está logado'));
      }

      if (appState.overrideCache == true) {
        final model = await despesasRepository.buscarDespesasMes(
          userId: userId,
          pData: DateFormat('yyyy-MM-dd')
              .format(appState.dataSelecionada ?? DateTime.now()),
        );
        await appState.salvarDespesasMes(model);
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
