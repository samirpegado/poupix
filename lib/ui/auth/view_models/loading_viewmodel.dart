import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:poupix/app_state/app_state.dart';
import 'package:poupix/data/repositories/categorias_repository.dart';
import 'package:poupix/domain/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoadingViewModel {
  final AppState appState;
  final supabase = Supabase.instance.client;

  LoadingViewModel({required this.appState});

  Future<void> init() async {
    await appState.carregar(); // carrega SharedPreferences locais
    await carregarUsuario();
    await buscarCategorias();
  }

  Future<void> carregarUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    final session = supabase.auth.currentSession;
    final user = session?.user;

    if (user == null) return;

    final saved = prefs.getString('usuario');
    if (saved != null) {
      final model = UserModel.fromJson(jsonDecode(saved));
      if (model.id == user.id) {
        appState.salvarUsuario(model);
        return;
      }
    }

    final response =
        await supabase.from('users').select().eq('id', user.id).single();
    final usuario = UserModel.fromMap(response);
    await appState.salvarUsuario(usuario);
  }

  Future<void> buscarCategorias() async {
    final categoriasRepository = CategoriasRepository();

    try {
      final userId = appState.usuario?.id;
      if (userId == null) return;

      if (appState.overrideCategorias) {
        final model = await categoriasRepository.getCategorias(userId: userId);
        await appState.salvarCategorias(model);
      } else {
        final cached = appState.categorias;
        if (cached == null) {
          debugPrint('Cache de categorias vazio.');
        }
      }
    } catch (e) {
      debugPrint('Erro ao buscar categorias: $e');
    }
  }
}
