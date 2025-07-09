import 'package:flutter/material.dart';
import 'package:poupix/app_state/app_state.dart';
import 'package:poupix/data/repositories/categorias_repository.dart';
import 'package:poupix/domain/models/categorias_model.dart';
import 'package:poupix/ui/core/themes/colors.dart';
import 'package:poupix/ui/core/themes/dimens.dart';
import 'package:poupix/ui/core/themes/theme.dart';
import 'package:poupix/ui/core/ui/input_decorations.dart';
import 'package:poupix/ui/core/ui/validators.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditarCategoria extends StatefulWidget {
  final Categorias categoria;
  const EditarCategoria({super.key, required this.categoria});

  @override
  State<EditarCategoria> createState() => _EditarCategoriaState();
}

class _EditarCategoriaState extends State<EditarCategoria> {
  late final nomeController = TextEditingController();
  final categoriasRepository = CategoriasRepository();

  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    nomeController.text = widget.categoria.titulo;
    super.initState();
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
                    'Editar categoria',
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
                    controller: nomeController,
                    decoration: AppInputDecorations.normal(
                      label: 'Nome',
                      icon: Icons.person_outlined,
                    ),
                    validator: AppValidators.nome(),
                  ),
                ],
              ),
            ),

            // Botões
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
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
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Salvar'),
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
    if (!_formKey.currentState!.validate()) return;

    final nome = nomeController.text.trim();
    final appState = context.read<AppState>();
    final userId = appState.usuario?.id;

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuário não identificado')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await Supabase.instance.client
          .from('categorias')
          .update({'titulo': nome}).eq('id', widget.categoria.id);

      if (response != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar')),
        );
        return;
      }

      final model = await categoriasRepository.getCategorias(userId: userId);
      await appState.salvarCategorias(model);

      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dados atualizados com sucesso')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }
}
