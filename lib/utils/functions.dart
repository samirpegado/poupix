import 'package:intl/intl.dart';
import 'package:poupix/domain/models/despesa.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

final NumberFormat currencyFormat =
    NumberFormat.simpleCurrency(locale: 'pt_BR');

List<DespesaModel> filtroDespesas(
  List<DespesaModel> lista,
  String? categoria,
) {
  // Se a lista for vazia ou ambos os filtros forem nulos/vazios, retorna a lista original
  if (lista.isEmpty ||
      (categoria == null || categoria.isEmpty || categoria == 'Todas')) {
    return lista;
  }

  return lista.where((despesa) {
    // Comparação de categoria
    final matchCategoria = (categoria.isEmpty)
        ? true
        : (despesa.categoriaTitulo.toLowerCase() == categoria.toLowerCase());

    return matchCategoria;
  }).toList();
}

Color? getColor(int index) {
  final hue = ((index + 1) * 40) % 360;
  return HSVColor.fromAHSV(1.0, hue.toDouble(), 1.0, 0.9).toColor();
}

Future<void> selecionarImagem(BuildContext context) async {
  if (kIsWeb) {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
    );

    if (result != null && result.files.single.bytes != null) {
      final bytes = result.files.single.bytes!;
      final nome = result.files.single.name;

      debugPrint('Imagem selecionada na web: $nome (${bytes.length} bytes)');
      // Exemplo: fazer upload com `bytes`
    } else {
      debugPrint('Nenhuma imagem selecionada na web');
    }
  } else {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Câmera'),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _pickImageMobile(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galeria'),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _pickImageMobile(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

Future<void> _pickImageMobile(ImageSource source) async {
  final picker = ImagePicker();
  final XFile? imagem = await picker.pickImage(source: source);

  if (imagem != null) {
    debugPrint('Imagem selecionada no mobile: ${imagem.path}');
    // Exemplo: upload ou salvar localmente
    // final File file = File(imagem.path);
  } else {
    debugPrint('Nenhuma imagem selecionada no mobile');
  }
}
