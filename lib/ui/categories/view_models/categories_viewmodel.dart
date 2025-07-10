import 'package:logging/logging.dart';
import 'package:poupix/app_state/app_state.dart';
import 'package:poupix/data/repositories/categorias_repository.dart';
import 'package:poupix/domain/models/categorias_model.dart';
import 'package:poupix/utils/command.dart';
import 'package:poupix/utils/result.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CategoriesViewModel {
  CategoriesViewModel({required this.appState}) {
    fetchCategorias = Command0<List<Categorias>>(() => _buscarCategorias());
    deleteCategoria = Command1<String, int>((id) => _removerCategoria(id));
    fetchCategorias.execute();
  }

  final AppState appState;
  final _logger = Logger('CategoriasViewModel');

  final categoriasRepository = CategoriasRepository();
  late final Command0<List<Categorias>> fetchCategorias;
  late final Command1<String, int> deleteCategoria;

  /// Carrega categorias, com opção de forçar atualização (ignorar cache)
  Future<Result<List<Categorias>>> _buscarCategorias(
      {bool force = false}) async {
    try {
      final userId = appState.usuario?.id;
      if (userId == null) {
        return Result.error(Exception('Usuário não está logado'));
      }

      final precisaAtualizar = appState.overrideCategorias || force;

      if (precisaAtualizar) {
        final model = await categoriasRepository.getCategorias(userId: userId);
        await appState.salvarCategorias(model);
        return Result.ok(model);
      } else {
        final cached = appState.categorias;
        return cached == null
            ? Result.error(Exception('Cache vazio'))
            : Result.ok(cached);
      }
    } catch (e, s) {
      _logger.severe('Erro ao buscar categorias: $e', e, s);
      return Result.error(Exception('Erro ao buscar categorias'));
    }
  }

  Future<Result<String>> _removerCategoria(int categoriaId) async {
    try {
       await Supabase.instance.client
          .from('categorias')
          .delete()
          .eq('id', categoriaId);
     
      await _buscarCategorias(force: true);



      return Result.ok('Categoria removida com sucesso');
    } catch (e) {
      return Result.error(Exception('Erro ao remover categorias'));
    }
  }
}
