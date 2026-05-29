import 'package:intl/intl.dart';
import 'package:poupix/domain/models/despesas_mes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DespesasRepository {
  final _client = Supabase.instance.client;

  Future<DespesasMesModel> buscarDespesasMes({
    required String userId,
    String? pData,
    String? pCategoria,
    String? pLiquidada,
  }) async {
    final hoje = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final response = await _client.rpc(
      'buscar_despesas_mes',
      params: {
        'p_categoria': pCategoria ?? '',
        'p_data': (pData == null || pData.isEmpty) ? hoje : pData,
        'p_liquidada': pLiquidada ?? '',
        'p_user_id': userId,
      },
    );

    final data = response as Map<String, dynamic>;
    return DespesasMesModel.fromJson(data);
  }

  Future<void> atualizarLiquidada({
    required int despesaId,
    required bool liquidada,
    required String tipo,
    required String userId,
    required DateTime mesReferencia,
  }) async {
    if (tipo == 'Fixa') {
      await _client.from('despesas_fixas_liquidacao').upsert(
        {
          'despesa_id': despesaId,
          'user_id': userId,
          'ano': mesReferencia.year,
          'mes': mesReferencia.month,
          'liquidada': liquidada,
        },
        onConflict: 'despesa_id,ano,mes',
      );
      return;
    }

    await _client
        .from('despesas')
        .update({'liquidada': liquidada}).eq('id', despesaId);
  }
}
