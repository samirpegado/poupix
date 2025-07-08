import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:poupix/app_state/app_state.dart';
import 'package:poupix/ui/components/month_picker.dart';
import 'package:poupix/ui/components/navbar.dart';
import 'package:poupix/ui/core/themes/colors.dart';
import 'package:poupix/ui/core/themes/dimens.dart';
import 'package:poupix/ui/core/themes/theme.dart';
import 'package:poupix/ui/home/view_models/home_viewmodel.dart';
import 'package:poupix/ui/home/widgets/doughnuts_categoria.dart';
import 'package:poupix/ui/home/widgets/barchart_tipo.dart';
import 'package:poupix/ui/home/widgets/empty_state_home.dart';
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
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return SafeArea(top: false,
      child: Scaffold(
        backgroundColor: AppColors.black1,
        bottomNavigationBar: const MyBottomNavBar(
          route: '/home',
        ),
        appBar: AppBar(
          backgroundColor: AppColors.black1,
          toolbarHeight: 0,
        ),
        body: Padding(
          padding: Dimens.of(context).edgeInsetsScreen,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              Row(
                children: [
                  ClipOval(
                    child: Image.network(
                      appState.usuario?.profilePic ??
                          'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/contas-bq58qy/assets/b0smeq7opmcb/emptyUser_(1).png',
                      fit: BoxFit.cover,
                      width: 40,
                      height: 40,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Olá, ${appState.usuario?.nome ?? 'Usuário'} 👋',
                        style: AppTheme.lightTheme.textTheme.titleMedium,
                      ),
                      Text(
                        'Vamos organizar seus gastos hoje?',
                        style: AppTheme.lightTheme.textTheme.titleSmall,
                      )
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
      
              /// Despesas por categoria
              Expanded(
                child: AnimatedBuilder(
                  animation: widget.viewModel.fetchDespesas,
                  builder: (context, _) {
                    final result = widget.viewModel.fetchDespesas.result;
      
                    if (widget.viewModel.fetchDespesas.running) {
                      return Center(
                        child: EmptyStateHome()
                      );
                    }
      
                    if (result is Ok) {
                      final model = result.value;
      
                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.grey1,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Padding(
                                padding: Dimens.of(context).edgeInsetsScreen,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Minhas despesas',
                                          style: AppTheme
                                              .lightTheme.textTheme.labelMedium,
                                        ),
                                        SizedBox(height: 6),
                                        Text(
                                          currencyFormat.format(model.total),
                                          style: AppTheme
                                              .lightTheme.textTheme.labelLarge,
                                        ),
                                        SizedBox(height: 6),
                                        Text(
                                          'Total mensal',
                                          style: AppTheme
                                              .lightTheme.textTheme.bodySmall,
                                        ),
                                      ],
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
                                                  await appState.salvarData(data);
                                                  await appState
                                                      .limparCacheDespesas();
                                                  await widget
                                                      .viewModel.fetchDespesas
                                                      .execute();
                                                },
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize
                                            .min, // importante pra evitar espaçamento extra
                                        children: [
                                          Icon(Icons.calendar_today,
                                              size: 18, color: Colors.white),
                                          const SizedBox(width: 8),
                                          Text(
                                            DateFormat('LLL y', 'pt_BR').format(
                                                appState.dataSelecionada ??
                                                    DateTime.now()),
                                            style: AppTheme.btnTextStyleWhite,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.grey1,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Padding(
                                padding: Dimens.of(context).edgeInsetsScreen,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Despesas por categoria',
                                          style: AppTheme
                                              .lightTheme.textTheme.labelMedium,
                                        ),
                                        Row(
                                          children: [
                                            InkWell(
                                              onTap: () =>
                                                  context.go('/expenses'),
                                              child: Text(
                                                'Ver mais',
                                                style: AppTheme.lightTheme
                                                    .textTheme.bodySmall,
                                              ),
                                            ),
                                            const Icon(
                                              Icons.arrow_right,
                                              color: AppColors.secondaryColor,
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    DoughnutsTotalCategoria(
                                      totalCategorias: model.totalCategoria,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.grey1,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Padding(
                                padding: Dimens.of(context).edgeInsetsScreen,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Despesas por tipo',
                                          style: AppTheme
                                              .lightTheme.textTheme.labelMedium,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    SimpleHorizontalBarChart(
                                        totalTipo: model.totalTipo)
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
      
                    if (result is Error) {
                      return const Text(
                        'Erro ao carregar despesas.',
                        style: TextStyle(color: Colors.red),
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
