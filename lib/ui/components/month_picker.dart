import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:poupix/ui/core/themes/colors.dart';
import 'package:poupix/ui/core/themes/dimens.dart';
import 'package:poupix/ui/core/themes/theme.dart';

class MonthPicker extends StatefulWidget {
  final DateTime? initDate;
  final void Function(DateTime)? onSelect;

  const MonthPicker({super.key, this.initDate, this.onSelect});

  @override
  State<MonthPicker> createState() => _MonthPickerState();
}

class _MonthPickerState extends State<MonthPicker> {
  late int year;
  late int selectedMonth;

  @override
  void initState() {
    final now = widget.initDate ?? DateTime.now();
    year = now.year;
    selectedMonth = now.month;
    super.initState();
  }

  void _selectMonth(int month) {
    setState(() {
      selectedMonth = month;
    });
  }

  void _changeYear(int offset) {
    setState(() {
      year += offset;
    });
  }

  @override
  Widget build(BuildContext context) {
    final DateTime selectedDate = DateTime(year, selectedMonth);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      constraints: const BoxConstraints(
        maxWidth: 320,
        maxHeight: 480,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            height: 110,
            decoration: const BoxDecoration(
              color: AppColors.black1,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Padding(
              padding: Dimens.of(context).edgeInsetsScreen,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'SELECIONE O MÊS/ANO',
                    style: TextStyle(color: Colors.white),
                  ),
                  Center(
                    child: Text(
                      DateFormat('LLL y', 'pt_BR').format(selectedDate),
                      style: AppTheme.lightTheme.textTheme.titleMedium
                          ?.copyWith(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Year selector
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$year',
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 12),
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () => _changeYear(-1),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () => _changeYear(1),
                ),
              ],
            ),
          ),

          // Grid de meses
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: List.generate(12, (index) {
                final month = index + 1;
                final isSelected = selectedMonth == month;

                return GestureDetector(
                  onTap: () => _selectMonth(month),
                  child: Container(
                    width: 60, // largura fixa
                    height: 60, // altura fixa
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.black1 : Colors.transparent,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      DateFormat('LLL', 'pt_BR').format(DateTime(0, month)),
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          const Spacer(),

          // Botões
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ButtonStyle(
                      minimumSize: WidgetStateProperty.all(
                        const Size.fromHeight(60),
                      ),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: Dimens.borderRadius,
                        ),
                      ),
                      elevation: WidgetStateProperty.all(2),
                    ),
                    child: const Text('Fechar'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      if (widget.onSelect != null) {
                        widget.onSelect!(DateTime(year, selectedMonth));
                      }
                      Navigator.of(context).pop();
                    },
                    style: ButtonStyle(
                      minimumSize: WidgetStateProperty.all(
                        const Size.fromHeight(60),
                      ),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: Dimens.borderRadius,
                        ),
                      ),
                      elevation: WidgetStateProperty.all(2),
                    ),
                    child: const Text('Selecionar'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
