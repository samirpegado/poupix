import 'package:brasil_fields/brasil_fields.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:poupix/app_state/app_state.dart';
import 'package:poupix/domain/models/categorias_model.dart';
import 'package:poupix/ui/add_expense/view_models/add_viewmodel.dart';
import 'package:poupix/ui/components/category_add.dart';
import 'package:poupix/ui/components/navbar.dart';
import 'package:poupix/ui/core/themes/colors.dart';
import 'package:poupix/ui/core/themes/dimens.dart';
import 'package:poupix/ui/core/themes/theme.dart';
import 'package:poupix/ui/core/ui/input_decorations.dart';
import 'package:poupix/ui/core/ui/validators.dart';
import 'package:poupix/utils/result.dart';
import 'package:provider/provider.dart';

class Add extends StatefulWidget {
  const Add({super.key, required this.viewModel});
  final AddViewModel viewModel;

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _valorController = TextEditingController();
  final _vencimentoController = TextEditingController();
  late final _qtdParcelasController = TextEditingController(text: '1');
  Categorias? selectedCategoria;
  String? tipo;
  int qtdParcelas = 1;

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    _valorController.dispose();
    _vencimentoController.dispose();
    _qtdParcelasController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Adicionar despesa',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
          backgroundColor: AppColors.black1,
        ),
        bottomNavigationBar: const MyBottomNavBar(
          route: '/add',
        ),
        body: Padding(
          padding: Dimens.of(context).edgeInsetsScreen,
          child: Form(
            key: _formKey,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Informações',
                    style: AppTheme.lightTheme.textTheme.labelMedium,
                  ),
                  const SizedBox(height: 16),

                  /// Titulo
                  TextFormField(
                    controller: _tituloController,
                    decoration: AppInputDecorations.normal(
                      label: 'Título',
                      icon: Icons.subtitles_outlined,
                    ),
                    validator: AppValidators.nome(),
                  ),
                  const SizedBox(height: 16),

                  /// Descricao
                  TextFormField(
                    controller: _descricaoController,
                    decoration: AppInputDecorations.normal(
                      label: 'Descrição',
                      icon: Icons.description_outlined,
                    ),
                    validator: AppValidators.nome(),
                  ),
                  const SizedBox(height: 16),

                  ///Valor
                  TextFormField(
                    controller: _valorController,
                    decoration: AppInputDecorations.normal(
                      label: 'Valor',
                      icon: Icons.money,
                    ),
                    validator: AppValidators.nome(),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CentavosInputFormatter(moeda: true)
                    ],
                  ),
                  const SizedBox(height: 16),

                  ///Vencimento
                  TextFormField(
                    controller: _vencimentoController,
                    readOnly: true,
                    onTap: () async {
                      FocusScope.of(context)
                          .requestFocus(FocusNode()); // remove o teclado

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
                        final dataFormatada =
                            UtilData.obterDataDDMMAAAA(dataSelecionada);
                        _vencimentoController.text = dataFormatada;
                      }
                    },
                    decoration: AppInputDecorations.normal(
                      label: 'Vencimento',
                      icon: Icons.calendar_today_outlined,
                    ),
                    validator: AppValidators.nome(),
                  ),
                  const SizedBox(height: 16),

                  /// Categorias
                  DropdownButtonFormField2<Categorias?>(
                    value: selectedCategoria,
                    style: TextStyle(color: AppColors.black1),
                    dropdownStyleData: DropdownStyleData(maxHeight: 300),
                    decoration: AppInputDecorations.normal(
                      label: 'Categorias',
                      icon: Icons.category_outlined,
                      suffix: IconButton(
                          icon: Icon(Icons.category_outlined),
                          onPressed: () {
                            setState(() {
                              selectedCategoria = null;
                            });
                            showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  insetPadding: EdgeInsets.zero,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: CategoryAdd(),
                                );
                              },
                            );
                          }),
                    ),
                    isExpanded: true,
                    items: appState.categorias
                        ?.map((categoria) => DropdownMenuItem<Categorias?>(
                              value: categoria,
                              child: Text(
                                categoria.titulo,
                                style: TextStyle(
                                  color: AppColors.black1,
                                  fontSize: 18,
                                ),
                              ),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedCategoria = value;
                        });
                      }
                    },
                    validator: (value) =>
                        value == null ? 'Selecione uma categoria' : null,
                  ),

                  const SizedBox(height: 16),

                  /// Tipo - Parcelas
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField2<String>(
                          isDense: true,
                          style: TextStyle(color: AppColors.black1),
                          dropdownStyleData: DropdownStyleData(maxHeight: 300),
                          decoration: AppInputDecorations.normal(
                            label: 'Tipo',
                            icon: Icons.type_specimen_outlined,
                          ),
                          isExpanded: true,
                          items: ['Única', 'Fixa', 'Parcelada']
                              .map((tipo) => DropdownMenuItem<String>(
                                    value: tipo,
                                    child: Text(
                                      tipo,
                                      style: TextStyle(
                                        color: AppColors.black1,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                tipo = value;
                              });
                            }
                          },
                          validator: (value) =>
                              value == null ? 'Selecione uma categoria' : null,
                        ),
                      ),
                      if (tipo == 'Parcelada') SizedBox(width: 16),
                      Visibility(
                        visible: tipo == 'Parcelada',
                        child: Expanded(
                          child: TextFormField(
                            onChanged: (value) {},
                            controller: _qtdParcelasController,
                            decoration: AppInputDecorations.normal(
                              label: 'Qtd de parcelas',
                              icon: Icons.numbers_rounded,
                            ),
                            inputFormatters: [
                              MaskTextInputFormatter(mask: '##')
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  ///Botao Salvar
                  SizedBox(height: 32),
                  AnimatedBuilder(
                    animation: widget.viewModel.salvarDespesa,
                    builder: (context, _) {
                      return FilledButton(
                        style: ButtonStyle(
                          minimumSize: WidgetStateProperty.all(
                              const Size.fromHeight(60)),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                                borderRadius: Dimens.borderRadius),
                          ),
                          elevation: WidgetStateProperty.all(2),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            widget.viewModel
                              ..titulo = _tituloController.text
                              ..descricao = _descricaoController.text
                              ..valorString = _valorController.text
                              ..vencimentoString = _vencimentoController.text
                              ..tipo = tipo
                              ..categoria = selectedCategoria
                              ..parcelas = tipo == 'Parcelada'
                                  ? int.tryParse(_qtdParcelasController.text) ??
                                      1
                                  : 1;

                            await widget.viewModel.salvarDespesa.execute();

                            if (mounted) {
                              final result =
                                  widget.viewModel.salvarDespesa.result;

                              if (result is Ok) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'Despesa adicionada com sucesso!')),
                                );
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  context.go('/expenses');
                                });
                              } else if (result is Error) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text('Erro: ${result.error}')),
                                );
                              }
                            }
                          }
                        },
                        child: widget.viewModel.salvarDespesa.running
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2.5, color: Colors.white),
                              )
                            : const Text('Salvar'),
                      );
                    },
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
