import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:poupix/ui/auth/view_models/login_viewmodel.dart';
import 'package:poupix/ui/core/themes/colors.dart';
import 'package:poupix/ui/core/ui/validators.dart';
import 'package:poupix/utils/result.dart';

class Login extends StatefulWidget {
  const Login({super.key, required this.viewModel});
  final LoginViewModel viewModel;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _showPassword = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),
                Center(
                  child: Image.asset(
                    'assets/poupix.png',
                    height: 72,
                  ),
                ),
                const SizedBox(height: 32),

                // Tab Login / Cadastro
                _TabSelector(
                  controller: _tabController,
                  onSignupTap: () => context.push('/signup'),
                ),

                const SizedBox(height: 40),

                // E-mail
                _FieldLabel('Seu E-mail'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(fontSize: 15),
                  decoration: _fieldDecoration(hint: 'contato@exemplo.com'),
                  validator: AppValidators.email(),
                ),

                const SizedBox(height: 20),

                // Senha
                _FieldLabel('Senha'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _senhaController,
                  obscureText: !_showPassword,
                  style: const TextStyle(fontSize: 15),
                  decoration: _fieldDecoration(
                    hint: '••••••••',
                    suffix: IconButton(
                      icon: Icon(
                        _showPassword
                            ? Icons.visibility_off_outlined
                            : Icons.remove_red_eye_outlined,
                        color: AppColors.secondaryText,
                        size: 20,
                      ),
                      onPressed: () =>
                          setState(() => _showPassword = !_showPassword),
                    ),
                  ),
                  validator: AppValidators.senha(),
                ),

                const SizedBox(height: 10),

                // Esqueci senha
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => context.push('/recovery'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'Esqueci a senha?',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Botão Entrar
                AnimatedBuilder(
                  animation: widget.viewModel.login,
                  builder: (context, _) {
                    return SizedBox(
                      height: 54,
                      child: FilledButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await widget.viewModel.login.execute((
                              _emailController.text,
                              _senhaController.text,
                            ));

                            final result = widget.viewModel.login.result;

                            if (result is Ok) {
                              if (mounted) context.go('/loading');
                            } else if (result is Error) {
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(result.error.toString()),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                );
                              }
                            }
                          }
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: widget.viewModel.login.running
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Continuar',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 28),

                // Divisor "Ou"
                const _OrDivider(),

                const SizedBox(height: 24),

                // Botão Google
                _SocialButton(
                  label: 'Entrar com Google',
                  icon: _GoogleIcon(),
                  onTap: () {},
                ),

                const SizedBox(height: 12),

                // Botão Apple
                _SocialButton(
                  label: 'Entrar com Apple',
                  icon: const Icon(Icons.apple, size: 22, color: Colors.black),
                  onTap: () {},
                ),

                const SizedBox(height: 32),

                // Cadastro
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Não tem conta? ',
                      style: TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 14,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => context.push('/signup'),
                      child: Text(
                        'Cadastre-se',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _fieldDecoration({required String hint, Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: AppColors.secondaryText, fontSize: 15),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppColors.grey2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppColors.grey2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.red1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.red1, width: 2),
      ),
    );
  }
}

// --- Widgets auxiliares ---

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppColors.primaryText,
      ),
    );
  }
}

class _TabSelector extends StatelessWidget {
  final TabController controller;
  final VoidCallback onSignupTap;
  const _TabSelector({required this.controller, required this.onSignupTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _TabItem(label: 'Entrar', isActive: true, onTap: () {}),
        const SizedBox(width: 24),
        _TabItem(label: 'Cadastrar', isActive: false, onTap: onSignupTap),
      ],
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  const _TabItem(
      {required this.label, required this.isActive, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: isActive ? AppColors.primary : AppColors.secondaryText,
            ),
          ),
          const SizedBox(height: 4),
          if (isActive)
            Container(
              height: 3,
              width: 40,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
        ],
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: AppColors.grey2, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Ou',
            style: TextStyle(
              color: AppColors.secondaryText,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(child: Divider(color: AppColors.grey2, thickness: 1)),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String label;
  final Widget icon;
  final VoidCallback onTap;
  const _SocialButton(
      {required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryText,
        side: BorderSide(color: AppColors.grey2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        minimumSize: const Size.fromHeight(54),
        padding: const EdgeInsets.symmetric(horizontal: 20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _GoogleIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 22,
      height: 22,
      child: CustomPaint(painter: _GooglePainter()),
    );
  }
}

class _GooglePainter extends CustomPainter {
  const _GooglePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2;

    // Arcos coloridos do G do Google
    final segments = [
      (0.0, 0.5, const Color(0xFF4285F4)),   // azul
      (0.5, 0.75, const Color(0xFF34A853)),  // verde
      (0.75, 0.875, const Color(0xFFFBBC05)), // amarelo
      (0.875, 1.0, const Color(0xFFEA4335)), // vermelho
    ];

    for (final (start, end, color) in segments) {
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3;
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: r - 1.5),
        start * 2 * 3.14159,
        (end - start) * 2 * 3.14159,
        false,
        paint,
      );
    }

    // Barra horizontal do G
    final barPaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(cx, cy),
      Offset(cx + r - 1.5, cy),
      barPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
