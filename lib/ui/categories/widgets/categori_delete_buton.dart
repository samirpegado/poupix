import 'package:flutter/material.dart';
import 'package:poupix/domain/models/categorias_model.dart';
import 'package:poupix/ui/categories/view_models/categories_viewmodel.dart';
import 'package:poupix/utils/result.dart';

class CategoriaDeleteButton extends StatefulWidget {
  const CategoriaDeleteButton({
    super.key,
    required this.categoria,
    required this.viewModel,
  });

  final Categorias categoria;
  final CategoriesViewModel viewModel;

  @override
  State<CategoriaDeleteButton> createState() => _CategoriaDeleteButtonState();
}

class _CategoriaDeleteButtonState extends State<CategoriaDeleteButton> {
  bool _isDeleting = false;
  Future<Result<String>> _confirmarExclusao() async {
    try {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirmar exclusão'),
          content: const Text('Tem certeza que deseja excluir esta categoria?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Excluir'),
            ),
          ],
        ),
      );

      if (confirmed == true) {
        setState(() {
          _isDeleting = true;
        });

        await widget.viewModel.deleteCategoria.execute(widget.categoria.id);

        setState(() {
          _isDeleting = false;
        });
      }
      String msg = 'Categoria excluida com sucesso';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg)),
      );
      return Result.ok(msg);
    } catch (e) {
      return Result.ok('Erro ao excluir cateoria');
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _confirmarExclusao,
      icon: _isDeleting
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.delete_forever, color: Colors.red),
      style: ButtonStyle(
        shape: WidgetStateProperty.all(
          const CircleBorder(side: BorderSide(color: Colors.red)),
        ),
      ),
    );
  }
}
