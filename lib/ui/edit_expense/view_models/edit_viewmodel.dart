import 'package:flutter/material.dart';
import 'package:poupix/app_state/app_state.dart';
import 'package:poupix/domain/models/categorias_model.dart';
import 'package:poupix/utils/command.dart';
import 'package:poupix/utils/result.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:brasil_fields/brasil_fields.dart';

class EditExpenseViewModel extends ChangeNotifier {
  final AppState appState;

  late final Command0<void> salvarDespesa;
  late final Command0<void> deletarDespesa;

  EditExpenseViewModel({required this.appState}) {
    salvarDespesa = Command0(_salvar);
    deletarDespesa = Command0(_deletarDespesa);
  }

  String? titulo;
  String? descricao;
  String? valorString;
  String? vencimentoString;
  String? tipo;
  Categorias? categoria;
  int parcelas = 1;

  Future<Result<void>> _salvar() async {
    try {
      final valor =
          double.tryParse(valorString!.replaceAll(RegExp(r'[^\d]'), '')) ?? 0.0;
      final valorFinal = valor / 100;

      final vencimento = UtilData.obterDateTime(vencimentoString!);

      int? despesaId = appState.despesaSelecionada?.despesaId;

      if (despesaId == null) {
        return Result.error(Exception('Despesa não encontrada'));
      }

      await Supabase.instance.client.from('despesas').update({
        'titulo': titulo,
        'descricao': descricao,
        'valor': valorFinal,
        'vencimento': vencimento.toIso8601String(),
        'tipo': tipo,
        'parcelas': tipo == 'Parcelada' ? parcelas : null,
        'categoria': categoria?.id,
      }).eq('id', appState.despesaSelecionada!.despesaId);

      await appState.limparCacheDespesas();

      return Result.ok(null);
    } catch (e) {
      return Result.error(Exception('Erro ao salvar despesa: $e'));
    }
  }

  Future<Result<void>> _deletarDespesa() async {
    int? despesaId = appState.despesaSelecionada?.despesaId;
    try {
      if (despesaId == null) {
        return Result.error(Exception('Despesa não encontrada'));
      }

      await Supabase.instance.client
          .from('despesas')
          .delete()
          .eq('id', appState.despesaSelecionada!.despesaId);
      appState.limparDespesaSelecionada();
      await appState.limparCacheDespesas();

      return Result.ok(null);
    } catch (e) {
      return Result.error(Exception('Erro ao deletar despesa: $e'));
    }
  }
}
