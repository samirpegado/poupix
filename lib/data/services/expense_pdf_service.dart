import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:poupix/domain/models/despesa.dart';
import 'package:poupix/utils/functions.dart';
import 'package:printing/printing.dart';

class ExpensePdfService {
  Future<void> exportDespesas({
    required DateTime mesReferencia,
    required List<DespesaModel> despesas,
    required double total,
    required double totalLiquidado,
    required double totalPendente,
    String? filtroCategoria,
    String? filtroSituacao,
  }) async {
    final fontRegular = await PdfGoogleFonts.openSansRegular();
    final fontBold = await PdfGoogleFonts.openSansBold();
    final theme = pw.ThemeData.withFont(
      base: fontRegular,
      bold: fontBold,
    );

    final mesLabel = DateFormat('MMMM yyyy', 'pt_BR').format(mesReferencia);
    final doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        theme: theme,
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Text(
              'Poupix - Despesas',
              style: pw.TextStyle(
                fontSize: 22,
                fontWeight: pw.FontWeight.bold,
                font: fontBold,
              ),
            ),
          ),
          pw.Text(
            mesLabel[0].toUpperCase() + mesLabel.substring(1),
            style: pw.TextStyle(fontSize: 14, font: fontRegular),
          ),
          if (filtroCategoria != null || filtroSituacao != null) ...[
            pw.SizedBox(height: 4),
            pw.Text(
              [
                if (filtroCategoria != null) 'Categoria: $filtroCategoria',
                if (filtroSituacao != null) 'Situação: $filtroSituacao',
              ].join(' | '),
              style: pw.TextStyle(
                fontSize: 10,
                color: PdfColors.grey700,
                font: fontRegular,
              ),
            ),
          ],
          pw.SizedBox(height: 16),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              _summaryCell('Total', total, fontRegular, fontBold),
              _summaryCell('Liquidado', totalLiquidado, fontRegular, fontBold),
              _summaryCell('Pendente', totalPendente, fontRegular, fontBold),
            ],
          ),
          pw.SizedBox(height: 20),
          pw.TableHelper.fromTextArray(
            headers: ['Título', 'Parcela', 'Categoria', 'Venc.', 'Valor', 'Situação'],
            headerStyle: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              font: fontBold,
            ),
            cellStyle: pw.TextStyle(font: fontRegular),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
            cellAlignments: {
              0: pw.Alignment.centerLeft,
              1: pw.Alignment.center,
              2: pw.Alignment.centerLeft,
              3: pw.Alignment.center,
              4: pw.Alignment.centerRight,
              5: pw.Alignment.center,
            },
            data: despesas.map((d) {
              final venc = d.vencimento.length >= 10
                  ? '${d.vencimento.substring(8, 10)}/${d.vencimento.substring(5, 7)}'
                  : d.vencimento;
              return [
                d.titulo,
                _parcelaText(d),
                d.categoriaTitulo,
                venc,
                currencyFormat.format(d.valor),
                d.liquidada ? 'Liquidada' : 'Pendente',
              ];
            }).toList(),
          ),
          pw.SizedBox(height: 24),
          pw.Text(
            'Gerado em ${DateFormat('dd/MM/yyyy HH:mm', 'pt_BR').format(DateTime.now())}',
            style: pw.TextStyle(
              fontSize: 9,
              color: PdfColors.grey600,
              font: fontRegular,
            ),
          ),
        ],
      ),
    );

    final fileName =
        'poupix-despesas-${DateFormat('yyyy-MM').format(mesReferencia)}.pdf';

    await Printing.sharePdf(
      bytes: await doc.save(),
      filename: fileName,
    );
  }

  String _parcelaText(DespesaModel despesa) {
    if (despesa.tipo != 'Parcelada') return '-';
    final atual = despesa.parcelaAtual ?? 0;
    final total = despesa.parcelas ?? 0;
    if (total == 0) return '-';
    return '$atual/$total';
  }

  pw.Widget _summaryCell(
    String label,
    double value,
    pw.Font fontRegular,
    pw.Font fontBold,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(fontSize: 10, font: fontRegular),
        ),
        pw.Text(
          currencyFormat.format(value),
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
            font: fontBold,
          ),
        ),
      ],
    );
  }
}
