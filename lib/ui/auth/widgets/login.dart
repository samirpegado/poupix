import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:poupix/ui/auth/view_models/login_viewmodel.dart';
import 'package:poupix/ui/core/themes/dimens.dart';
import 'package:poupix/ui/core/themes/theme.dart';

import 'package:poupix/ui/core/ui/input_decorations.dart';
import 'package:poupix/ui/core/ui/validators.dart';
import 'package:poupix/utils/result.dart';

class Login extends StatefulWidget {
  const Login({super.key, required this.viewModel});
  final LoginViewModel viewModel;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: Dimens.of(context).edgeInsetsScreen,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 32),
                Image.asset(
                  'assets/poupix.png',
                  width: 200,
                ),
                SizedBox(height: 16),
                Text('Login',
                    style: AppTheme.lightTheme.textTheme.headlineLarge),
                SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: AppInputDecorations.normal(
                    label: 'E-mail',
                    icon: Icons.mail_outline,
                  ),
                  validator: AppValidators.email(),
                ),
                const SizedBox(height: 16),
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
                SizedBox(height: 16),
                InkWell(
                  onTap: () => context.push('/recovery'),
                  child: Row(
                    children: [
                      Text(
                        'Esqueci minha senha',
                        style: AppTheme.btnTextStyleBlack,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                InkWell(
                  onTap: () {
                    context.push('/signup');
                  },
                  child: Row(
                    children: [
                      Text('Ainda não tem registro? '),
                      Text(
                        'Acesse aqui',
                        style: AppTheme.btnTextStyleBlack,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                AnimatedBuilder(
                  animation: widget.viewModel.login,
                  builder: (context, _) {
                    return FilledButton(
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
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await widget.viewModel.login.execute((
                            _emailController.text,
                            _senhaController.text,
                          ));

                          final result = widget.viewModel.login.result;

                          if (result is Ok) {
                            if (mounted) {
                              context.go('/loading');
                            }
                          } else if (result is Error) {
                            final message = result.error.toString();
                            if (mounted) {
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(SnackBar(content: Text(message)));
                            }
                          }
                        }
                      },
                      child: widget.viewModel.login.running
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Entrar'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
