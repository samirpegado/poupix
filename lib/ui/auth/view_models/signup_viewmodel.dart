import 'package:poupix/data/services/auth_service.dart';
import 'package:poupix/domain/models/response_model.dart';
import 'package:poupix/utils/command.dart';
import 'package:poupix/utils/result.dart';

class SignUpViewModel {
  final AuthService authService;
  late final Command1<ResponseModel, AccountParams> createAccount;

  SignUpViewModel({required this.authService}) {
    createAccount = Command1<ResponseModel, AccountParams>(_createAccount);
  }

  Future<Result<ResponseModel>> _createAccount(AccountParams params) async {
    try {
      final result = await authService.createAccount(
          email: params.email,
          password: params.password,
          cpf: params.cpf,
          celular: params.celular,
          nome: params.nome);
      return Result.ok(result);
    } catch (e) {
      return Result.error(Exception('Erro ao criar conta: $e'));
    }
  }
}

class AccountParams {
  final String email;
  final String nome;
  final String password;
  final String cpf;
  final String celular;

  AccountParams({
    required this.email,
    required this.nome,
    required this.password,
    required this.cpf,
    required this.celular,
  });
}
