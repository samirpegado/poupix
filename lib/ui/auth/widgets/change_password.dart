import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:poupix/domain/models/response_model.dart';
import 'package:poupix/ui/auth/view_models/change_password_viewmodel.dart';
import 'package:poupix/ui/core/themes/colors.dart';
import 'package:poupix/ui/core/themes/dimens.dart';
import 'package:poupix/ui/core/themes/theme.dart';
import 'package:poupix/ui/core/ui/input_decorations.dart';
import 'package:poupix/ui/core/ui/validators.dart';
import 'package:poupix/utils/result.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key, required this.viewModel});
  final ChangePasswordViewModel viewModel;

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  final _senhaController = TextEditingController();
  final _senha2Controller = TextEditingController();
  bool _showPassword = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => context.go('/profile'),
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.white,
            ),
          ),
          title: Text(
            'Alterar senha',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
          backgroundColor: AppColors.black1,
        ),
        body: Padding(
          padding: Dimens.of(context).edgeInsetsScreen,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'assets/poupix.png',
                        width: 80,
                      ),
                      Text('Redefina sua senha',
                          style: AppTheme.lightTheme.textTheme.labelLarge),
                      SizedBox(width: 80)
                    ],
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _senhaController,
                    obscureText: !_showPassword,
                    decoration: AppInputDecorations.password(
                      label: 'Nova senha',
                      isVisible: _showPassword,
                      onToggleVisibility: () {
                        setState(() => _showPassword = !_showPassword);
                      },
                    ),
                    validator: AppValidators.senha(),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _senha2Controller,
                    obscureText: !_showPassword,
                    decoration: AppInputDecorations.password(
                      label: 'Confirmar senha',
                      isVisible: _showPassword,
                      onToggleVisibility: () {
                        setState(() => _showPassword = !_showPassword);
                      },
                    ),
                    validator: AppValidators.senha(),
                  ),
                  const SizedBox(height: 32),
                  AnimatedBuilder(
                    animation: widget.viewModel.changePassword,
                    builder: (context, _) {
                      return FilledButton(
                        style: ButtonStyle(
                          minimumSize: WidgetStateProperty.all(
                              const Size.fromHeight(60)),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: Dimens.borderRadius,
                            ),
                          ),
                          elevation: WidgetStateProperty.all(2),
                        ),
                        onPressed: widget.viewModel.changePassword.running
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  await widget.viewModel.changePassword.execute(
                                    PasswordParams(
                                      password: _senhaController.text,
                                      confirmPassword: _senha2Controller.text,
                                    ),
                                  );

                                  final result =
                                      widget.viewModel.changePassword.result;

                                  if (result case Ok<ResponseModel>()) {
                                    final response = result.value;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(response.message)),
                                    );
                                    if (response.success && mounted) {
                                      context.go('/profile');
                                    }
                                  } else if (result is Error) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text(result.error.toString())),
                                    );
                                  }
                                }
                              },
                        child: widget.viewModel.changePassword.running
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Alterar senha'),
                      );
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
