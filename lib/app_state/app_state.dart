import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:poupix/domain/models/despesas_mes.dart';
import 'package:poupix/domain/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppState extends ChangeNotifier {
  UserModel? _usuario;
  DespesasMesModel? _despesasMes;
  bool _overrideCache = true;
  DateTime? _dataSelecionada;

  UserModel? get usuario => _usuario;
  DespesasMesModel? get despesasMes => _despesasMes;
  bool get overrideCache => _overrideCache;
  DateTime? get dataSelecionada => _dataSelecionada;

  Future<void> carregar() async {
    final prefs = await SharedPreferences.getInstance();
    final usuarioJson = prefs.getString('usuario');
    final despesasJson = prefs.getString('despesasMes');
    final overrideCache = prefs.getBool('overrideCache');
    final dataSalva = prefs.getString('dataSelecionada');

    if (usuarioJson != null) {
      _usuario = UserModel.fromJson(jsonDecode(usuarioJson));
    }

    if (dataSalva == null) {
      _dataSelecionada = DateTime.now();
    } else {
      _dataSelecionada = DateTime.parse(dataSalva);
    }

    try {
      if (despesasJson != null) {
        final decoded = jsonDecode(despesasJson);

        if (decoded is Map<String, dynamic>) {
          _despesasMes = DespesasMesModel.fromJson(decoded);
        } else if (decoded is String) {
          // Isso acontece se você salvou o JSON como string *duplamente* codificada
          _despesasMes = DespesasMesModel.fromJson(jsonDecode(decoded));
        } else {
          throw Exception('Formato inválido para despesasMes');
        }
      }
    } catch (e) {
      debugPrint('Erro ao carregar despesasMes do cache: $e');
    }

    _overrideCache = overrideCache ?? true;
    notifyListeners();
  }

  Future<void> salvarData(DateTime data) async {
    _dataSelecionada = data;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('dataSelecionada', data.toIso8601String());
    notifyListeners();
  }

  Future<void> salvarUsuario(UserModel usuario) async {
    _usuario = usuario;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('usuario', jsonEncode(usuario.toJson()));
    notifyListeners();
  }

  Future<void> salvarDespesasMes(DespesasMesModel despesas) async {
    _despesasMes = despesas;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('despesasMes', jsonEncode(despesas.toJson()));
    await prefs.setBool('overrideCache', false);
    _overrideCache = false;
    notifyListeners();
  }

  Future<void> limparCacheDespesas() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('despesasMes');
    await prefs.remove('overrideCache');
    _despesasMes = null;
    _overrideCache = true;
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    _usuario = null;
    _despesasMes = null;
    _overrideCache = true;
    notifyListeners();
  }

  Future<void> atualizarUsuario({required String nome, required String celular}) async {
      if (_usuario == null) return;

  _usuario = _usuario!.copyWith(
    nome: nome,
    celular: celular,
  );

  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('usuario', jsonEncode(_usuario!.toJson()));
  notifyListeners();
  }
}
