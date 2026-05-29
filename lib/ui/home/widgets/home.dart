import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:poupix/app_state/app_state.dart';
import 'package:poupix/ui/components/month_picker.dart';
import 'package:poupix/ui/components/navbar.dart';
import 'package:poupix/ui/core/themes/colors.dart';
import 'package:poupix/ui/core/themes/dimens.dart';
import 'package:poupix/ui/core/themes/theme.dart';
import 'package:poupix/ui/core/ui/app_empty_state.dart';
import 'package:poupix/ui/home/view_models/home_viewmodel.dart';
import 'package:poupix/ui/home/widgets/doughnuts_categoria.dart';
import 'package:poupix/ui/home/widgets/barchart_tipo.dart';
import 'package:poupix/ui/components/user_avatar.dart';
import 'package:poupix/utils/functions.dart';
import 'package:poupix/utils/result.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.viewModel});

  final HomeViewModel viewModel;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<void> _refresh() async {
    final appState = context.read<AppState>();
    await appState.limparCacheDespesas();
    await widget.viewModel.fetchDespesas.execute();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: AppColors.background,
        bottomNavigationBar: const MyBottomNavBar(route: '/home'),
        body: Padding(
          padding: Dimens.of(context).edgeInsetsScreen,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.black1, AppColors.primary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const UserAvatar(size: 44),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Olá, ${appState.usuario?.nome ?? 'Usuário'} 👋',
                            style: AppTheme.lightTheme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Vamos organizar seus gastos hoje?',
                            style: AppTheme.lightTheme.textTheme.titleSmall
                                ?.copyWith(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: AnimatedBuilder(
                  animation: widget.viewModel.fetchDespesas,
                  builder: (context, _) {
                    final result = widget.viewModel.fetchDespesas.result;

                    if (widget.viewModel.fetchDespesas.running) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                        ),
                      );
                    }

                    if (result is Ok) {
                      final model = result.value;
                      final semDespesas = model.despesas.isEmpty;

                      return RefreshIndicator(
                        color: AppColors.primary,
                        onRefresh: _refresh,
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Column(
                            children: [
                              Container(
                                decoration: AppTheme.cardDecoration,
                                child: Padding(
                                  padding:
                                      Dimens.of(context).edgeInsetsScreen,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Minhas despesas',
                                              style: AppTheme.lightTheme
                                                  .textTheme.labelMedium,
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              currencyFormat.format(model.total),
                                              style: AppTheme.lightTheme
                                                  .textTheme.labelLarge,
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              'Liquidado: ${currencyFormat.format(model.totalLiquidado)} · Pendente: ${currencyFormat.format(model.totalPendente)}',
                                              style: AppTheme.lightTheme
                                                  .textTheme.bodySmall,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Total mensal',
                                              style: AppTheme.lightTheme
                                                  .textTheme.bodySmall,
                                            ),
                                          ],
                                        ),
                                      ),
                                      FilledButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return Dialog(
                                                insetPadding: EdgeInsets.zero,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                ),
                                                child: MonthPicker(
                                                  initDate:
                                                      appState.dataSelecionada,
                                                  onSelect: (data) async {
                                                    await appState
                                                        .salvarData(data);
                                                    await appState
                                                        .limparCacheDespesas();
                                                    await widget.viewModel
                                                        .fetchDespesas
                                                        .execute();
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
                                                  .format(appState
                                                          .dataSelecionada ??
                                                      DateTime.now()),
                                              style: AppTheme.btnTextStyleWhite,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (semDespesas) ...[
                                const SizedBox(height: 24),
                                AppEmptyState(
                                  icon: Icons.receipt_long_outlined,
                                  title: 'Nenhuma despesa neste mês',
                                  subtitle:
                                      'Adicione sua primeira despesa para acompanhar seus gastos.',
                                  actionLabel: 'Ver despesas',
                                  onAction: () => context.go('/expenses'),
                                ),
                              ] else ...[
                                const SizedBox(height: 16),
                                Container(
                                  decoration: AppTheme.cardDecoration,
                                  child: Padding(
                                    padding:
                                        Dimens.of(context).edgeInsetsScreen,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Despesas por categoria',
                                              style: AppTheme.lightTheme
                                                  .textTheme.labelMedium,
                                            ),
                                            InkWell(
                                              onTap: () =>
                                                  context.go('/expenses'),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'Ver mais',
                                                    style: AppTheme.lightTheme
                                                        .textTheme.bodySmall,
                                                  ),
                                                  const Icon(
                                                    Icons.arrow_right,
                                                    color: AppColors
                                                        .secondaryColor,
                                                    size: 18,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        DoughnutsTotalCategoria(
                                          totalCategorias:
                                              model.totalCategoria,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Container(
                                  decoration: AppTheme.cardDecoration,
                                  child: Padding(
                                    padding:
                                        Dimens.of(context).edgeInsetsScreen,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Despesas por tipo',
                                          style: AppTheme.lightTheme.textTheme
                                              .labelMedium,
                                        ),
                                        const SizedBox(height: 16),
                                        SimpleHorizontalBarChart(
                                          totalTipo: model.totalTipo,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      );
                    }

                    if (result is Error) {
                      return Center(
                        child: AppEmptyState(
                          icon: Icons.cloud_off_outlined,
                          title: 'Não foi possível carregar as despesas',
                          subtitle: 'Verifique sua conexão e tente novamente.',
                          actionLabel: 'Tentar novamente',
                          onAction: () =>
                              widget.viewModel.fetchDespesas.execute(),
                        ),
                      );
                    }

                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
