import 'package:brasil_fields/brasil_fields.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:poupix/app_state/app_state.dart';
import 'package:poupix/domain/models/categorias_model.dart';
import 'package:poupix/ui/add_expense/view_models/add_viewmodel.dart';
import 'package:poupix/ui/components/category_add.dart';
import 'package:poupix/ui/components/expense_modal_shell.dart';
import 'package:poupix/ui/core/themes/dimens.dart';
import 'package:poupix/ui/core/ui/feedback.dart';
import 'package:poupix/ui/core/ui/input_decorations.dart';
import 'package:poupix/ui/core/ui/validators.dart';
import 'package:poupix/utils/result.dart';
import 'package:provider/provider.dart';

Future<bool?> showAddExpenseModal(BuildContext context) {
  return showExpenseDialog<bool>(
    context: context,
    child: AddExpenseModal(viewModel: AddViewModel(appState: context.read())),
  );
}

class AddExpenseModal extends StatefulWidget {
  const AddExpenseModal({super.key, required this.viewModel});

  final AddViewModel viewModel;

  @override
  State<AddExpenseModal> createState() => _AddExpenseModalState();
}

class _AddExpenseModalState extends State<AddExpenseModal> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _valorController = TextEditingController();
  final _vencimentoController = TextEditingController();
  final _qtdParcelasController = TextEditingController(text: '1');
  Categorias? selectedCategoria;
  String? tipo;

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    _valorController.dispose();
    _vencimentoController.dispose();
    _qtdParcelasController.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;

    widget.viewModel
      ..titulo = _tituloController.text
      ..descricao = _descricaoController.text
      ..valorString = _valorController.text
      ..vencimentoString = _vencimentoController.text
      ..tipo = tipo
      ..categoria = selectedCategoria
      ..parcelas = tipo == 'Parcelada'
          ? int.tryParse(_qtdParcelasController.text) ?? 1
          : 1;

    await widget.viewModel.salvarDespesa.execute();

    if (!mounted) return;
    final result = widget.viewModel.salvarDespesa.result;

    if (result is Ok) {
      showSuccessSnackBar(context, 'Despesa adicionada com sucesso!');
      Navigator.of(context).pop(true);
    } else if (result is Error) {
      showErrorSnackBar(context, errorMessage(result.error));
    }
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return ExpenseModalShell(
      title: 'Nova despesa',
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _tituloController,
                textCapitalization: TextCapitalization.words,
                decoration: AppInputDecorations.normal(
                  label: 'Título',
                  icon: Icons.subtitles_outlined,
                ),
                validator: AppValidators.nome(),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descricaoController,
                textCapitalization: TextCapitalization.sentences,
                decoration: AppInputDecorations.normal(
                  label: 'Descrição',
                  icon: Icons.description_outlined,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _valorController,
                decoration: AppInputDecorations.normal(
                  label: 'Valor',
                  icon: Icons.attach_money,
                ),
                validator: AppValidators.nome(),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CentavosInputFormatter(moeda: true),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _vencimentoController,
                readOnly: true,
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  final dataSelecionada = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    helpText: 'Selecione a data de vencimento',
                    cancelText: 'Cancelar',
                    confirmText: 'Confirmar',
                  );
                  if (dataSelecionada != null) {
                    _vencimentoController.text =
                        UtilData.obterDataDDMMAAAA(dataSelecionada);
                  }
                },
                decoration: AppInputDecorations.normal(
                  label: 'Vencimento',
                  icon: Icons.calendar_today_outlined,
                ),
                validator: AppValidators.nome(),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField2<Categorias?>(
                value: selectedCategoria,
                style: const TextStyle(color: Colors.black),
                dropdownStyleData: DropdownStyleData(maxHeight: 280),
                decoration: AppInputDecorations.normal(
                  label: 'Categoria',
                  icon: Icons.category_outlined,
                  suffix: IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          insetPadding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const CategoryAdd(),
                        ),
                      );
                    },
                  ),
                ),
                isExpanded: true,
                items: appState.categorias
                    ?.map(
                      (categoria) => DropdownMenuItem<Categorias?>(
                        value: categoria,
                        child: Text(categoria.titulo),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => selectedCategoria = value),
                validator: (value) =>
                    value == null ? 'Selecione uma categoria' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField2<String>(
                style: const TextStyle(color: Colors.black),
                dropdownStyleData: DropdownStyleData(maxHeight: 280),
                decoration: AppInputDecorations.normal(
                  label: 'Tipo',
                  icon: Icons.type_specimen_outlined,
                ),
                isExpanded: true,
                items: const [
                  DropdownMenuItem(value: 'Única', child: Text('Única')),
                  DropdownMenuItem(
                    value: 'Fixa',
                    child: Text('Recorrente (mensal)'),
                  ),
                  DropdownMenuItem(value: 'Parcelada', child: Text('Parcelada')),
                ],
                onChanged: (value) => setState(() => tipo = value),
                validator: (value) =>
                    value == null ? 'Selecione o tipo' : null,
              ),
              if (tipo == 'Parcelada') ...[
                const SizedBox(height: 12),
                TextFormField(
                  controller: _qtdParcelasController,
                  decoration: AppInputDecorations.normal(
                    label: 'Quantidade de parcelas',
                    icon: Icons.numbers_rounded,
                  ),
                  inputFormatters: [MaskTextInputFormatter(mask: '##')],
                ),
              ],
              const SizedBox(height: 20),
              AnimatedBuilder(
                animation: widget.viewModel.salvarDespesa,
                builder: (context, _) {
                  return Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: widget.viewModel.salvarDespesa.running
                              ? null
                              : () => Navigator.of(context).pop(false),
                          style: ButtonStyle(
                            minimumSize: WidgetStateProperty.all(
                              const Size.fromHeight(52),
                            ),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: Dimens.borderRadius,
                              ),
                            ),
                          ),
                          child: const Text('Cancelar'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: FilledButton(
                          onPressed: widget.viewModel.salvarDespesa.running
                              ? null
                              : _salvar,
                          style: ButtonStyle(
                            minimumSize: WidgetStateProperty.all(
                              const Size.fromHeight(52),
                            ),
                            shape: WidgetStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: Dimens.borderRadius,
                              ),
                            ),
                          ),
                          child: widget.viewModel.salvarDespesa.running
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Salvar'),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
