import 'package:flutter/material.dart';
import 'package:poupix/app_state/app_state.dart';
import 'package:poupix/ui/components/delete_account.dart';
import 'package:poupix/ui/core/themes/colors.dart';
import 'package:poupix/ui/core/themes/dimens.dart';
import 'package:poupix/ui/core/themes/theme.dart';
import 'package:poupix/ui/core/ui/input_decorations.dart';
import 'package:poupix/ui/core/ui/mask_formaters.dart';
import 'package:poupix/ui/core/ui/validators.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ManageAccount extends StatefulWidget {
  const ManageAccount({super.key});

  @override
  State<ManageAccount> createState() => _ManageAccountState();
}

class _ManageAccountState extends State<ManageAccount> {
  late final TextEditingController nomeController;
  late final TextEditingController celularController;
  late final AppState appState;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    appState = context.read<AppState>();
    nomeController = TextEditingController(text: appState.usuario?.nome ?? '');
    celularController =
        TextEditingController(text: appState.usuario?.celular ?? '');
  }

  @override
  void dispose() {
    nomeController.dispose();
    celularController.dispose();
    super.dispose();
  }

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
                  child: Text(
                    'Gerir conta',
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
                  TextFormField(
                    controller: nomeController,textCapitalization: TextCapitalization.words,
                    decoration: AppInputDecorations.normal(
                      label: 'Nome',
                      icon: Icons.person_outlined,
                    ),
                    validator: AppValidators.nome(),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: celularController,
                    inputFormatters: [phoneFormatter],
                    keyboardType: TextInputType.number,
                    decoration: AppInputDecorations.normal(
                      label: 'Celular',
                      icon: Icons.phone_android_outlined,
                    ),
                    validator: AppValidators.celular(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: FilledButton(
                onPressed: _salvarAlteracoes,
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
                child: isLoading
                    ? CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : Text('Salvar'),
              ),
            ),
            // Botões
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                                insetPadding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: DeleteAccount());
                          },
                        );
                      },
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

  Future<void> _salvarAlteracoes() async {
    final SupabaseClient supabase = Supabase.instance.client;
    if (!_formKey.currentState!.validate()) return;

    final nome = nomeController.text.trim();
    final celular = celularController.text.trim();
    final userId = context.read<AppState>().usuario?.id;

    if (userId == null) return;
    setState(() {
      isLoading = true;
    });

    final response = await supabase.from('users').update({
      'nome': nome,
      'celular': celular,
    }).eq('id', userId);

    setState(() {
      isLoading = false;
    });

    if (response != null) {
      // Tratar erro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao salvar')),
      );
    } else {
      // Atualizar o AppState se necessário
      context.read<AppState>().atualizarUsuario(nome: nome, celular: celular);

      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dados atualizados com sucesso')),
      );
    }
  }
}
