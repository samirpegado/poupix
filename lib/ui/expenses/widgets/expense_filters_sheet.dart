import 'package:flutter/material.dart';
import 'package:poupix/ui/core/themes/colors.dart';
import 'package:poupix/ui/core/themes/dimens.dart';

class ExpenseFilters {
  const ExpenseFilters({
    this.categoria,
    this.situacao,
  });

  final String? categoria;
  final String? situacao;

  bool get hasActiveFilters =>
      (categoria != null && categoria != 'Todas') ||
      (situacao != null && situacao != 'Todas');
}

Future<ExpenseFilters?> showExpenseFiltersSheet(
  BuildContext context, {
  required List<String> categorias,
  required ExpenseFilters initial,
}) {
  return showModalBottomSheet<ExpenseFilters>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => _ExpenseFiltersSheet(
      categorias: categorias,
      initial: initial,
    ),
  );
}

class _ExpenseFiltersSheet extends StatefulWidget {
  const _ExpenseFiltersSheet({
    required this.categorias,
    required this.initial,
  });

  final List<String> categorias;
  final ExpenseFilters initial;

  @override
  State<_ExpenseFiltersSheet> createState() => _ExpenseFiltersSheetState();
}

class _ExpenseFiltersSheetState extends State<_ExpenseFiltersSheet> {
  static const _situacoes = ['Todas', 'Liquidadas', 'Pendentes'];

  late String _categoria;
  late String _situacao;

  @override
  void initState() {
    super.initState();
    _categoria = widget.initial.categoria ?? 'Todas';
    _situacao = widget.initial.situacao ?? 'Todas';
  }

  void _limpar() {
    setState(() {
      _categoria = 'Todas';
      _situacao = 'Todas';
    });
  }

  void _aplicar() {
    Navigator.pop(
      context,
      ExpenseFilters(
        categoria: _categoria == 'Todas' ? null : _categoria,
        situacao: _situacao == 'Todas' ? null : _situacao,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filtros',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryText,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Categoria',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.categorias.map((cat) {
              return FilterChip(
                label: Text(cat),
                selected: _categoria == cat,
                selectedColor: AppColors.alternate,
                checkmarkColor: AppColors.primary,
                onSelected: (_) => setState(() => _categoria = cat),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          const Text(
            'Situação',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.primaryText,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _situacoes.map((sit) {
              return FilterChip(
                label: Text(sit),
                selected: _situacao == sit,
                selectedColor: AppColors.alternate,
                checkmarkColor: AppColors.primary,
                onSelected: (_) => setState(() => _situacao = sit),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _limpar,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: Dimens.borderRadius,
                    ),
                  ),
                  child: const Text('Limpar'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: _aplicar,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: Dimens.borderRadius,
                    ),
                  ),
                  child: const Text('Aplicar'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
