import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:poupix/app_state/app_state.dart';
import 'package:poupix/ui/components/month_picker.dart';
import 'package:poupix/ui/components/navbar.dart';
import 'package:poupix/ui/core/themes/colors.dart';
import 'package:poupix/ui/core/themes/dimens.dart';
import 'package:poupix/ui/core/themes/theme.dart';
import 'package:poupix/ui/core/ui/input_decorations.dart';
import 'package:poupix/ui/expenses/view_models/expenses_viewmodel.dart';
import 'package:poupix/ui/expenses/widgets/expense_item.dart';
import 'package:poupix/utils/result.dart';
import 'package:provider/provider.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key, required this.viewModel});
  final ExpensesViewModel viewModel;

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    final appState = context.watch<AppState>();

    final despesasFiltradas = viewModel.despesasFiltradas;
    final categorias = viewModel.categorias;
    final total = viewModel.total;

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Despesas',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
          backgroundColor: AppColors.black1,
          actions: [
            FilledButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      insetPadding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: MonthPicker(
                        initDate: appState.dataSelecionada,
                        onSelect: (data) async {
                          await appState.salvarData(data);
                          await appState.limparCacheDespesas();
                          await viewModel.fetchDespesas.execute();
                        },
                      ),
                    );
                  },
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.calendar_today,
                      size: 18, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    DateFormat('LLL y', 'pt_BR')
                        .format(appState.dataSelecionada ?? DateTime.now()),
                    style: AppTheme.btnTextStyleWhite,
                  ),
                ],
              ),
            )
          ],
        ),
        bottomNavigationBar: const MyBottomNavBar(route: '/expenses'),
        body: AnimatedBuilder(
          animation: widget.viewModel.fetchDespesas,
          builder: (context, _) {
            final result = widget.viewModel.fetchDespesas.result;

            if (widget.viewModel.fetchDespesas.running) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (result is Ok) {
              return Padding(
                padding: Dimens.of(context).edgeInsetsScreen,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total',
                            style: AppTheme.lightTheme.textTheme.labelLarge),
                        Text(
                          NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$')
                              .format(total),
                          style: AppTheme.lightTheme.textTheme.labelLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    if (categorias.isNotEmpty)
                      DropdownButtonFormField2<String>(
                      isDense: true,
                      style: TextStyle(color: AppColors.black1),
                      dropdownStyleData: DropdownStyleData(maxHeight: 600),
                      decoration: AppInputDecorations.normal(
                        label: 'Filtrar por categoria',
                        icon: Icons.category_outlined,
                      ),
                      isExpanded: true,
                      items: categorias
                          .map((categoria) => DropdownMenuItem<String>(
                                value: categoria,
                                child: Text(
                                  categoria,
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
                             setState(() {
                            viewModel.selecionarCategoria(value);
                          });
                          });
                        }
                      },
                      validator: (value) =>
                          value == null ? 'Selecione uma categoria' : null,
                    ),
                     const SizedBox(height: 16),
                    Expanded(
                      child: despesasFiltradas.isEmpty
                          ? const Center(
                              child: Text('Nenhuma despesa a ser listada'),
                            )
                          : ListView.builder(
                              itemCount: despesasFiltradas.length,
                              itemBuilder: (context, index) {
                                final despesa = despesasFiltradas[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: InkWell( 
                                    onTap: () {
                                      appState.selecionarDespesa(despesa) ;
                                      context.push('/edit');
                                    },
                                    child: ExpenseItem(despesa: despesa)),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              );
            } else if (result is Error) {
              return const Center(
                child: Text('Erro ao carregar despesas.'),
              );
            } else {
              return const Center(
                child: Text('Nenhum dado disponível.'),
              );
            }
          },
        ),
      ),
    );
  }
}
