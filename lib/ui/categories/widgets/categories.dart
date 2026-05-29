import 'package:flutter/material.dart';
import 'package:poupix/app_state/app_state.dart';
import 'package:poupix/ui/categories/view_models/categories_viewmodel.dart';
import 'package:poupix/ui/categories/widgets/categori_delete_buton.dart';
import 'package:poupix/ui/components/category_add.dart';
import 'package:poupix/ui/components/category_edit.dart';
import 'package:poupix/ui/components/navbar.dart';
import 'package:poupix/ui/core/themes/colors.dart';
import 'package:poupix/ui/core/themes/dimens.dart';
import 'package:poupix/ui/core/themes/theme.dart';
import 'package:poupix/ui/core/ui/app_empty_state.dart';
import 'package:poupix/ui/core/ui/input_decorations.dart';
import 'package:poupix/utils/functions.dart' show getColor;
import 'package:provider/provider.dart';

class Categories extends StatefulWidget {
  const Categories({super.key, required this.viewModel});
  final CategoriesViewModel viewModel;

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  final _buscaController = TextEditingController();

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userIdAppState = widget.viewModel.appState.usuario?.id ?? '';
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Categorias',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
        ),
        bottomNavigationBar: const MyBottomNavBar(route: '/categories'),
        body: Padding(
          padding: Dimens.of(context).edgeInsetsScreen,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _buscaController,
                      decoration: AppInputDecorations.normal(
                        label: 'Buscar',
                        icon: Icons.search,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    onPressed: () {
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
                    },
                    icon: const Icon(Icons.add_rounded, color: Colors.white),
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all(AppColors.primary),
                      fixedSize: WidgetStateProperty.all(const Size(50, 50)),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: _buscaController,
                  builder: (context, _, __) {
                    final todasCategorias =
                        context.watch<AppState>().categorias ?? [];

                    final query = _buscaController.text.toLowerCase();
                    final categoriasFiltradas = todasCategorias.where((cat) {
                      return cat.titulo.toLowerCase().contains(query);
                    }).toList();

                    if (categoriasFiltradas.isEmpty) {
                      final buscando = query.isNotEmpty;
                      return RefreshIndicator(
                        color: AppColors.primary,
                        onRefresh: widget.viewModel.refresh,
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            AppEmptyState(
                              icon: buscando
                                  ? Icons.search_off_outlined
                                  : Icons.category_outlined,
                              title: buscando
                                  ? 'Nenhuma categoria encontrada'
                                  : 'Nenhuma categoria cadastrada',
                              subtitle: buscando
                                  ? 'Tente outro termo de busca.'
                                  : 'Toque no + para criar sua primeira categoria.',
                            ),
                          ],
                        ),
                      );
                    }

                    return RefreshIndicator(
                      color: AppColors.primary,
                      onRefresh: widget.viewModel.refresh,
                      child: ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: categoriasFiltradas.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final categoria = categoriasFiltradas[index];
                          final cor = getColor(categoria.id);

                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: AppTheme.cardDecoration,
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: cor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.category,
                                      color: Colors.white, size: 20),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    categoria.titulo,
                                    style: AppTheme
                                        .lightTheme.textTheme.labelMedium,
                                  ),
                                ),
                                if (categoria.userId == userIdAppState &&
                                    userIdAppState.isNotEmpty)
                                  Row(
                                    children: [
                                      IconButton(
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
                                                child: EditarCategoria(
                                                  categoria: categoria,
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        icon: const Icon(Icons.edit_rounded,
                                            color: AppColors.secondaryText),
                                      ),
                                      CategoriaDeleteButton(
                                        categoria: categoria,
                                        viewModel: widget.viewModel,
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
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
