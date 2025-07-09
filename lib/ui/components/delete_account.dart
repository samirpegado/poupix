import 'package:flutter/material.dart';
import 'package:poupix/app_state/app_state.dart';
import 'package:poupix/data/repositories/auth_repository.dart';
import 'package:poupix/data/services/auth_service.dart';
import 'package:poupix/ui/core/themes/colors.dart';
import 'package:poupix/ui/core/themes/dimens.dart';
import 'package:poupix/ui/core/themes/theme.dart';
import 'package:poupix/ui/core/ui/input_decorations.dart';
import 'package:poupix/ui/core/ui/validators.dart';
import 'package:provider/provider.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({super.key});

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  bool _showPassword = false;
  bool isLoading = false;
  final _senhaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      constraints: const BoxConstraints(
        maxWidth: 320,
        maxHeight: 480,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              height: 80,
              decoration: const BoxDecoration(
                color: AppColors.black1,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Padding(
                padding: Dimens.of(context).edgeInsetsScreen,
                child: Center(
                  child: isLoading
                      ? CircularProgressIndicator()
                      : Text(
                          'Excluir conta',
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(color: Colors.white),
                        ),
                ),
              ),
            ),

            Padding(
              padding: Dimens.of(context).edgeInsetsScreen,
              child: Column(
                children: [
                  Text(
                    '''Tem certeza de que deseja excluir sua conta?

Essa ação é irreversível. Todos os seus dados serão permanentemente removidos e você não poderá recuperá-los depois.

Se estiver decidido, confirme sua senha para prosseguir com a exclusão.''',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.red1,
                    ),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _senhaController,
                    obscureText: !_showPassword,
                    decoration: AppInputDecorations.password(
                      label: 'Senha',
                      isVisible: _showPassword,
                      onToggleVisibility: () {
                        setState(() => _showPassword = !_showPassword);
                      },
                    ),
                    validator: AppValidators.senha(),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: _deleteAccount,
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all<Color>(AppColors.red1),
                        minimumSize: WidgetStateProperty.all(
                          const Size.fromHeight(60),
                        ),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: Dimens.borderRadius,
                          ),
                        ),
                        elevation: WidgetStateProperty.all(2),
                      ),
                      child: const Text(
                        'Excluir conta',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ButtonStyle(
                        minimumSize: WidgetStateProperty.all(
                          const Size.fromHeight(60),
                        ),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: Dimens.borderRadius,
                          ),
                        ),
                        elevation: WidgetStateProperty.all(2),
                      ),
                      child: const Text('Fechar'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteAccount() async {
    if (!_formKey.currentState!.validate()) return;

    final password = _senhaController.text.trim();
    final user = context.read<AppState>().usuario;
    final authService = AuthService();

    if (user == null) return;
    setState(() {
      isLoading = true;
    });

    final response = await authService.deleteAccount(
        userId: user.id, email: user.email, password: password);

    setState(() {
      isLoading = false;
    });

    if (response.success) {
      // Tratar erro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.message)),
      );
      await context.read<AppState>().logout();
      await context.read<AuthRepository>().logout();
    } else {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.message)),
      );
    }
  }
}
