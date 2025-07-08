import 'package:intl/intl.dart';
import 'package:poupix/domain/models/despesas_mes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DespesasRepository {
  final _client = Supabase.instance.client;

  Future<DespesasMesModel> buscarDespesasMes({
    required String userId,
    String? pData,

  }) async {
    final hoje = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final response = await _client.rpc(
      'buscar_despesas_mes',
      params: {
        'p_categoria': '',
        'p_data': (pData == null || pData.isEmpty) ? hoje : pData,
        'p_liquidada': '',
        'p_user_id': userId,
      },
    );    

    final data = response as Map<String, dynamic>;
    return DespesasMesModel.fromJson(data);
  }
}
