import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:poupix/domain/models/response_model.dart';
import 'package:poupix/ui/auth/view_models/signup_viewmodel.dart';
import 'package:poupix/ui/core/themes/colors.dart';
import 'package:poupix/ui/core/themes/dimens.dart';
import 'package:poupix/ui/core/themes/theme.dart';
import 'package:poupix/ui/core/ui/input_decorations.dart';
import 'package:poupix/ui/core/ui/mask_formaters.dart';
import 'package:poupix/ui/core/ui/validators.dart';
import 'package:poupix/utils/result.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key, required this.viewModel});
  final SignUpViewModel viewModel;

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _celularController = TextEditingController();
  final _cpfController = TextEditingController();
  final _emailController = TextEditingController();
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
            onPressed: () => context.go('/login'),
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.white,
            ),
          ),
          title: Text(
            'Criar conta',
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
                      Text('Insira seus dados',
                          style: AppTheme.lightTheme.textTheme.labelLarge),
                      SizedBox(width: 80)
                    ],
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _nomeController,
                    textCapitalization: TextCapitalization.words,
                    decoration: AppInputDecorations.normal(
                      label: 'Nome',
                      icon: Icons.person_outlined,
                    ),
                    validator: AppValidators.nome(),
                  ),
                  const SizedBox(height: 16),
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
                    controller: _celularController,
                    inputFormatters: [phoneFormatter],
                    keyboardType: TextInputType.number,
                    decoration: AppInputDecorations.normal(
                      label: 'Celular',
                      icon: Icons.phone_android_outlined,
                    ),
                    validator: AppValidators.celular(),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _cpfController,
                    inputFormatters: [cpfFomatter],
                    keyboardType: TextInputType.number,
                    decoration: AppInputDecorations.normal(
                      label: 'CPF',
                      icon: Icons.badge_outlined,
                    ),
                    validator: AppValidators.nome(),
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
                  SizedBox(height: 16),
                  InkWell(
                      onTap: () => context.go('/policy'),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text:
                                    'Ao criar sua conta você concorda com nossos ',
                                style: AppTheme
                                    .lightTheme.textTheme.displayMedium),
                            TextSpan(
                                text: 'Termos de Uso e Política de Privacidade',
                                style:
                                    AppTheme.lightTheme.textTheme.labelMedium),
                          ],
                        ),
                      )),
                  const SizedBox(height: 32),
                  AnimatedBuilder(
                    animation: widget.viewModel.createAccount,
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
                        onPressed: widget.viewModel.createAccount.running
                            ? null
                            : () async {
                                if (_formKey.currentState!.validate()) {
                                  final params = AccountParams(
                                    email: _emailController.text,
                                    nome: _nomeController.text,
                                    password: _senhaController.text,
                                    cpf: _cpfController.text,
                                    celular: _celularController.text,
                                  );

                                  await widget.viewModel.createAccount
                                      .execute(params);

                                  final result =
                                      widget.viewModel.createAccount.result;
                                  if (result is Ok<ResponseModel>) {
                                    final response = result.value;
                                    if (response.success) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(response.message)),
                                      );
                                      if (mounted) context.go('/login');
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(response.message)),
                                      );
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
                        child: widget.viewModel.createAccount.running
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Criar conta'),
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
