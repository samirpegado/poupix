import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:poupix/ui/core/themes/colors.dart';
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
    return SafeArea(top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Buy me a coffee',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
          backgroundColor: AppColors.black1,
        ),
       
        body: Padding(
          padding: Dimens.of(context).edgeInsetsScreen,
          child: SingleChildScrollView(
            child: Column(children: [
              Image.asset(
                'assets/poupix.png',
                width: 200,
              ),
              SizedBox(height: 16),
              SelectableText(
                '''Este app é 100% gratuito e feito pra te ajudar a organizar seus gastos. 
                \nSe ele te ajudou de alguma forma e você quiser apoiar o projeto, você pode me enviar um Pix:
                \n💸 56.990.326/0001-68
                \n56.990.326 SAMIR PEGADO GOMES''',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: '56.990.326/0001-68'));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Chave pix copiada para a área de transferência!')),
                  );
                },
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
                child: Text('Copiar chave pix'),
              ),
              SizedBox(height: 16),
              OutlinedButton(
                onPressed: () => context.go('/profile'),
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
                child: Text('Voltar'),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
