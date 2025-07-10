import 'package:flutter/material.dart';
import 'package:poupix/app_state/app_state.dart';
import 'package:poupix/domain/models/categorias_model.dart';
import 'package:poupix/utils/command.dart';
import 'package:poupix/utils/result.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:brasil_fields/brasil_fields.dart';

class AddViewModel extends ChangeNotifier {
  final AppState appState;

  late final Command0<void> salvarDespesa;

  AddViewModel({required this.appState}) {
    salvarDespesa = Command0(_salvar);
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
      final userId = appState.usuario?.id;
      if (userId == null) {
        return Result.error(Exception('Usuário não autenticado'));
      }

      final valor = double.tryParse(valorString!.replaceAll(RegExp(r'[^\d]'), '')) ?? 0.0;
      final valorFinal = valor / 100;

      final vencimento = UtilData.obterDateTime(vencimentoString!);

      await Supabase.instance.client.from('despesas').insert({
        'user_id': userId,
        'titulo': titulo,
        'descricao': descricao,
        'valor': valorFinal,
        'vencimento': vencimento.toIso8601String(),
        'tipo': tipo,
        'parcelas': tipo == 'Parcelada' ? parcelas : null,
        'categoria': categoria?.id,
      });

      await appState.limparCacheDespesas();

      return Result.ok(null);
    } catch (e) {
      return Result.error(Exception('Erro ao salvar despesa: $e'));
    }
  }
}
