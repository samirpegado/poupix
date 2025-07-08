import 'dart:convert';
import 'package:poupix/app_state/app_state.dart';
import 'package:poupix/domain/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoadingViewModel {
  final AppState appState;
  final supabase = Supabase.instance.client;

  LoadingViewModel({required this.appState});

  Future<void> carregarUsuario() async {    
    final prefs = await SharedPreferences.getInstance();
    final session = supabase.auth.currentSession;
    final user = session?.user;

    if (user == null) {
      // Usuário não logado
      return;
    }

    // Verifica se os dados do usuário estão no SharedPreferences e salva no app state
    final saved = prefs.getString('usuario');
    if (saved != null) {
      final model = UserModel.fromJson(jsonDecode(saved));
      if (model.id == user.id) {
        appState.salvarUsuario(model);
        return;
      }
    }

    // Se não tem ou o ID não bate, busca da tabela `users`
    final response = await supabase
        .from('users')
        .select()
        .eq('id', user.id)
        .single();

    final usuario = UserModel.fromMap(response);
    await appState.salvarUsuario(usuario);
  }
}
