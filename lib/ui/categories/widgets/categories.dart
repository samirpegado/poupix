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
          backgroundColor: AppColors.black1,
        ),
        bottomNavigationBar: const MyBottomNavBar(
          route: '/categories',
        ),
        body: Padding(
          padding: Dimens.of(context).edgeInsetsScreen,
          child: Column(children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _buscaController,
                    decoration: AppInputDecorations.normal(
                      label: 'Busca',
                      icon: Icons.search,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                IconButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                            insetPadding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: CategoryAdd());
                      },
                    );
                  },
                  icon: Icon(
                    Icons.add_rounded,
                    color: Colors.white,
                  ),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(AppColors.black1),
                    fixedSize: WidgetStateProperty.all(const Size(50, 50)),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  ),
                )
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

                  return ListView.separated(
                    itemCount: categoriasFiltradas.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final categoria = categoriasFiltradas[index];
                      final cor = getColor(categoria.id);

                      return Row(
                        children: [
                          // Ícone circular com cor baseada no índice
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: cor,
                              shape: BoxShape.circle,
                            ),
                            child:
                                const Icon(Icons.category, color: Colors.white),
                          ),

                          const SizedBox(width: 12),
                          // Título da categoria
                          Expanded(
                            child: Text(
                              categoria.titulo,
                              style: AppTheme.lightTheme.textTheme.labelMedium,
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Botão editar
                          if (categoria.userId == userIdAppState &&
                              userIdAppState.isNotEmpty)
                            Row(children: [
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
                                          ));
                                    },
                                  );
                                },
                                icon: const Icon(Icons.edit_rounded,
                                    color: Colors.grey),
                                style: ButtonStyle(
                                  shape: WidgetStateProperty.all(
                                    CircleBorder(
                                        side: BorderSide(
                                            color: Colors.grey.shade400)),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              // Botão excluir
                              CategoriaDeleteButton(
                                  categoria: categoria,
                                  viewModel: widget.viewModel)
                            ]),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
