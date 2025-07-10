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

        if (mounted) {
          final result = widget.viewModel.deleteCategoria.result;

          if (result is Ok) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Categoria excluída com sucesso!')),
            );
            setState(() {
          _isDeleting = false;
        });
            return Result.ok('Categoria excluída com sucesso!');
            
          } else if (result is Error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Erro: ${result.error}')),
            );
            setState(() {
          _isDeleting = false;
        });
            return Result.error(Exception('Erro ao excluir categoria'));
          }
        }

        setState(() {
          _isDeleting = false;
        });
      }

      // ⛔ Caso o usuário cancele ou nada aconteça
      return Result.error(Exception('Exclusão cancelada pelo usuário'));
    } catch (e) {
      return Result.error(Exception('Erro ao excluir categoria'));
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
