import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:poupix/ui/core/themes/dimens.dart';
import 'package:poupix/ui/core/themes/theme.dart';

class Donate extends StatefulWidget {
  const Donate({super.key});

  @override
  State<Donate> createState() => _DonateState();
}

class _DonateState extends State<Donate> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Apoie o projeto',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
        ),
        body: Padding(
          padding: Dimens.of(context).edgeInsetsScreen,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(
                  'assets/poupix.png',
                  width: 180,
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: AppTheme.cardDecoration,
                  child: const SelectableText(
                    'Este app é 100% gratuito e feito para te ajudar a organizar seus gastos.\n\n'
                    'Se ele te ajudou de alguma forma e você quiser apoiar o projeto, '
                    'você pode me enviar um Pix:\n\n'
                    '💸 56.990.326/0001-68\n'
                    '56.990.326 SAMIR PEGADO GOMES',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, height: 1.5),
                  ),
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: () {
                    Clipboard.setData(
                        const ClipboardData(text: '56.990.326/0001-68'));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Chave Pix copiada para a área de transferência!'),
                      ),
                    );
                  },
                  style: ButtonStyle(
                    minimumSize: WidgetStateProperty.all(
                      const Size.fromHeight(54),
                    ),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: Dimens.borderRadius,
                      ),
                    ),
                  ),
                  child: const Text('Copiar chave Pix'),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => context.go('/profile'),
                  style: ButtonStyle(
                    minimumSize: WidgetStateProperty.all(
                      const Size.fromHeight(54),
                    ),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: Dimens.borderRadius,
                      ),
                    ),
                  ),
                  child: const Text('Voltar'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
