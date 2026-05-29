import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:poupix/domain/models/response_model.dart';
import 'package:poupix/environment.dart';

class AuthService {
  Map<String, String> get _headers => {
        'apikey': anonKey,
        'Content-Type': 'application/json',
      };

  Future<ResponseModel> sendOtp({required String userId}) async {
    final url = Uri.parse('$supabaseUrl/functions/v1/send-otp');

    final body = json.encode({
      'user_id': userId,
    });

    try {
      final response = await http.post(url, body: body, headers: _headers);
      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return ResponseModel(
          success: true,
          message: data['message'] ?? 'Código enviado com sucesso.',
        );
      } else {
        return ResponseModel(
          success: false,
          message: data['message'] ?? 'Erro ao enviar código.',
        );
      }
    } catch (e) {
      return ResponseModel(
        success: false,
        message: 'Erro de conexão: $e',
      );
    }
  }

  Future<ResponseModel> deleteAccount({
    required String userId,
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$supabaseUrl/functions/v1/delete-account');

    final body = json.encode({
      'user_id': userId,
      'email': email,
      'password': password,
    });

    try {
      final response = await http.post(url, body: body, headers: _headers);
      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return ResponseModel(
          success: true,
          message: data['message'] ?? 'Conta excluída com sucesso.',
        );
      } else {
        return ResponseModel(
          success: false,
          message: data['message'] ?? 'Erro ao excluir conta.',
        );
      }
    } catch (e) {
      return ResponseModel(
        success: false,
        message: 'Erro de conexão: $e',
      );
    }
  }

  Future<ResponseModel> recoveryPasswordMobile({required String email}) async {
    final url = Uri.parse('$supabaseUrl/functions/v1/recover-password-mobile');

    final body = json.encode({
      'email': email,
    });

    try {
      final response = await http.post(url, body: body, headers: _headers);
      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return ResponseModel(
          success: true,
          message: data['message'] ?? 'Requisição processada',
        );
      } else {
        return ResponseModel(
          success: false,
          message: data['message'] ?? 'Erro ao processar requisição',
        );
      }
    } catch (e) {
      return ResponseModel(
        success: false,
        message: 'Erro de conexão: $e',
      );
    }
  }

  Future<ResponseModel> resetPasswordMobile({
    required String email,
    required String otpCode,
    required String password,
    required String confirmPassword,
  }) async {
    final url = Uri.parse('$supabaseUrl/functions/v1/reset-password-mobile');

    final body = json.encode({
      'email': email,
      'otp_code': otpCode,
      'new_password': password,
    });

    if (password != confirmPassword) {
      return ResponseModel(
        success: false,
        message: 'As senhas não coincidem.',
      );
    }

    try {
      final response = await http.post(url, body: body, headers: _headers);
      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return ResponseModel(
          success: true,
          message: data['message'] ?? 'Requisição processada',
        );
      } else {
        return ResponseModel(
          success: false,
          message: data['message'] ?? 'Erro ao processar requisição',
        );
      }
    } catch (e) {
      return ResponseModel(
        success: false,
        message: 'Erro de conexão: $e',
      );
    }
  }

  Future<ResponseModel> verifyOtp({
    required String userId,
    required String otpCode,
  }) async {
    final url = Uri.parse('$supabaseUrl/functions/v1/verify-otp');

    final body = json.encode({
      'user_id': userId,
      'otp_code': otpCode,
    });

    try {
      final response = await http.post(url, body: body, headers: _headers);
      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return ResponseModel(
          success: true,
          message: data['message'] ?? 'Conta verificada com sucesso.',
        );
      } else {
        return ResponseModel(
          success: false,
          message: data['message'] ?? 'Erro ao verificar código.',
        );
      }
    } catch (e) {
      return ResponseModel(
        success: false,
        message: 'Erro de conexão: $e',
      );
    }
  }

  Future<ResponseModel> createAccount({
    required String email,
    required String password,
    required String cpf,
    required String celular,
    required String nome,
  }) async {
    final url = Uri.parse('$supabaseUrl/functions/v1/create-account');

    final body = json.encode({
      'nome': nome,
      'email': email,
      'password': password,
      'cpf': cpf,
      'celular': celular,
    });

    try {
      final response = await http.post(url, body: body, headers: _headers);
      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return ResponseModel(
          success: true,
          message: data['message'] ?? 'Conta criada com sucesso.',
        );
      } else {
        return ResponseModel(
          success: false,
          message: data['message'] ?? 'Erro ao criar conta.',
        );
      }
    } catch (e) {
      return ResponseModel(
        success: false,
        message: 'Erro de conexão: $e',
      );
    }
  }
}
