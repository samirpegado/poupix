import 'package:intl/intl.dart';
import 'package:logging/logging.dart';
import 'package:poupix/app_state/app_state.dart';
import 'package:poupix/data/repositories/despesas_repository.dart';
import 'package:poupix/domain/models/despesas_mes.dart';
import 'package:poupix/utils/command.dart';
import 'package:poupix/utils/result.dart';

class HomeViewModel {
  HomeViewModel({required this.appState}) {
    fetchDespesas = Command0<DespesasMesModel>(_buscarDespesas);
    fetchDespesas.execute(); // executa automaticamente ao instanciar
  }

  final AppState appState;
  final _logger = Logger('HomeViewModel');

  final despesasRepository = DespesasRepository();
  late final Command0<DespesasMesModel> fetchDespesas;

  late DateTime date;

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
                .format(appState.dataSelecionada ?? DateTime.now()));
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
