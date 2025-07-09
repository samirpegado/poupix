import 'package:poupix/domain/models/categorias_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CategoriasRepository {
  final _client = Supabase.instance.client;

  Future<List<Categorias>> getCategorias({
    required String userId,
  }) async {
    final response = await _client.rpc(
      'get_categorias',
      params: {
        'p_user_id': userId,
      },
    );

    if (response is List) {
      return response
          .map((item) => Categorias.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Formato inválido de resposta da função get_categorias');
    }
  }
}
