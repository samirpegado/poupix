import 'package:flutter/material.dart';
import 'package:poupix/app_state/app_state.dart';
import 'package:poupix/data/services/expense_pdf_service.dart';
import 'package:poupix/domain/models/despesa.dart';
import 'package:poupix/ui/add_expense/widgets/add_expense.dart';
import 'package:poupix/ui/components/expense_summary.dart';
import 'package:poupix/ui/components/month_picker.dart';
import 'package:poupix/ui/components/navbar.dart';
import 'package:poupix/ui/core/themes/colors.dart';
import 'package:poupix/ui/core/themes/dimens.dart';
import 'package:poupix/ui/core/themes/theme.dart';
import 'package:poupix/ui/core/ui/app_empty_state.dart';
import 'package:poupix/ui/core/ui/feedback.dart';
import 'package:poupix/ui/edit_expense/widgets/edit_expense.dart';
import 'package:poupix/ui/expenses/view_models/expenses_viewmodel.dart';
import 'package:poupix/ui/expenses/widgets/expense_filters_sheet.dart';
import 'package:poupix/ui/expenses/widgets/expense_item.dart';
import 'package:poupix/ui/expenses/widgets/expense_toolbar.dart';
import 'package:poupix/utils/result.dart';
import 'package:provider/provider.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key, required this.viewModel});
  final ExpensesViewModel viewModel;

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final _pdfService = ExpensePdfService();

  Future<void> _refreshAfterChange() async {
    await widget.viewModel.fetchDespesas.execute();
    if (mounted) setState(() {});
  }

  Future<void> _openAddModal() async {
    final saved = await showAddExpenseModal(context);
    if (saved == true) await _refreshAfterChange();
  }

  Future<void> _openEditModal(DespesaModel despesa) async {
    final saved = await showEditExpenseModal(context, despesa: despesa);
    if (saved == true) await _refreshAfterChange();
  }

  Future<void> _toggleLiquidada(DespesaModel despesa, bool _) async {
    final result = await widget.viewModel.alternarLiquidada(despesa);
    if (!mounted) return;
    if (result is Error) {
      showErrorSnackBar(context, errorMessage(result.error));
    } else {
      setState(() {});
    }
  }

  Future<void> _openMonthPicker() async {
    final appState = context.read<AppState>();
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
              await _refreshAfterChange();
            },
          ),
        );
      },
    );
  }

  Future<void> _openFilters() async {
    final viewModel = widget.viewModel;
    final result = await showExpenseFiltersSheet(
      context,
      categorias: viewModel.categorias,
      initial: viewModel.filtrosAtivos,
    );

    if (result == null || !mounted) return;

    setState(() {
      if (!result.hasActiveFilters) {
        viewModel.limparFiltros();
      } else {
        viewModel.aplicarFiltros(result);
      }
    });
  }

  Future<void> _exportPdf() async {
    final viewModel = widget.viewModel;
    final appState = context.read<AppState>();

    if (viewModel.despesasFiltradas.isEmpty) {
      showErrorSnackBar(context, 'Não há despesas para exportar.');
      return;
    }

    try {
      await _pdfService.exportDespesas(
        mesReferencia: appState.dataSelecionada ?? DateTime.now(),
        despesas: viewModel.despesasFiltradas,
        total: viewModel.total,
        totalLiquidado: viewModel.totalLiquidado,
        totalPendente: viewModel.totalPendente,
        filtroCategoria: viewModel.categoriaSelecionada,
        filtroSituacao: viewModel.filtroLiquidada,
      );
    } catch (e) {
      if (mounted) {
        showErrorSnackBar(context, 'Não foi possível gerar o PDF.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    final appState = context.watch<AppState>();

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Despesas',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _openAddModal,
          child: const Icon(Icons.add),
        ),
        bottomNavigationBar: const MyBottomNavBar(route: '/expenses'),
        body: AnimatedBuilder(
          animation: widget.viewModel.fetchDespesas,
          builder: (context, _) {
            final result = widget.viewModel.fetchDespesas.result;

            if (widget.viewModel.fetchDespesas.running) {
              return const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              );
            }

            if (result is Error) {
              return Center(
                child: AppEmptyState(
                  icon: Icons.cloud_off_outlined,
                  title: 'Não foi possível carregar as despesas',
                  subtitle: 'Verifique sua conexão e tente novamente.',
                  actionLabel: 'Tentar novamente',
                  onAction: _refreshAfterChange,
                ),
              );
            }

            if (result is! Ok) {
              return const Center(
                child: AppEmptyState(
                  icon: Icons.receipt_long_outlined,
                  title: 'Nenhum dado disponível',
                ),
              );
            }

            final despesasFiltradas = viewModel.despesasFiltradas;

            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () async {
                await appState.limparCacheDespesas();
                await _refreshAfterChange();
              },
              child: Padding(
                padding: Dimens.of(context).edgeInsetsScreen,
                child: Column(
                  children: [
                    ExpenseToolbar(
                      mesReferencia:
                          appState.dataSelecionada ?? DateTime.now(),
                      filtersActive: viewModel.temFiltrosAtivos,
                      onMonthTap: _openMonthPicker,
                      onFiltersTap: _openFilters,
                      onExportTap: _exportPdf,
                    ),
                    if (viewModel.temFiltrosAtivos) ...[
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Wrap(
                          spacing: 6,
                          runSpacing: 4,
                          children: [
                            if (viewModel.categoriaSelecionada != null)
                              Chip(
                                label: Text(viewModel.categoriaSelecionada!),
                                deleteIcon: const Icon(Icons.close, size: 16),
                                onDeleted: () => setState(() {
                                  viewModel.categoriaSelecionada = null;
                                }),
                              ),
                            if (viewModel.filtroLiquidada != null)
                              Chip(
                                label: Text(viewModel.filtroLiquidada!),
                                deleteIcon: const Icon(Icons.close, size: 16),
                                onDeleted: () => setState(() {
                                  viewModel.filtroLiquidada = null;
                                }),
                              ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    ExpenseSummary(
                      total: viewModel.total,
                      totalLiquidado: viewModel.totalLiquidado,
                      totalPendente: viewModel.totalPendente,
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: despesasFiltradas.isEmpty
                          ? ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: [
                                AppEmptyState(
                                  icon: Icons.filter_list_off_outlined,
                                  title: viewModel.despesas.isEmpty
                                      ? 'Nenhuma despesa neste mês'
                                      : 'Nenhuma despesa encontrada',
                                  subtitle: viewModel.despesas.isEmpty
                                      ? 'Toque no + para adicionar sua primeira despesa.'
                                      : 'Ajuste os filtros para ver outras despesas.',
                                  actionLabel: viewModel.despesas.isEmpty
                                      ? 'Adicionar despesa'
                                      : 'Limpar filtros',
                                  onAction: viewModel.despesas.isEmpty
                                      ? _openAddModal
                                      : () => setState(viewModel.limparFiltros),
                                ),
                              ],
                            )
                          : ListView.separated(
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: despesasFiltradas.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 8),
                              itemBuilder: (context, index) {
                                final despesa = despesasFiltradas[index];
                                return ExpenseItem(
                                  despesa: despesa,
                                  onTap: () => _openEditModal(despesa),
                                  onToggleLiquidada: (value) =>
                                      _toggleLiquidada(despesa, value),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
