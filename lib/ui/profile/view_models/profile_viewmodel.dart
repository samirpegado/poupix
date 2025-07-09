import 'package:flutter/material.dart';
import 'package:poupix/app_state/app_state.dart';
import 'package:poupix/data/repositories/storage_repository.dart';
import 'package:poupix/utils/functions.dart';

class ProfileViewModel extends ChangeNotifier {
  final AppState appState;
  final StorageRepository storageRepository;

  ProfileViewModel({
    required this.appState,
    required this.storageRepository,
  });

  Future<void> alterarFoto(BuildContext context) async {
    final userId = appState.usuario?.id;
    if (userId == null) return;

    final imagem = await selecionarImagem(context, userId);
    if (imagem == null) return;

    final userData = await storageRepository.uploadProfilePic(
      userId: userId,
      imagem: imagem,
    );

    // 🔥 Bust cache da URL da imagem
    final bustedUrl = '${userData.profilePic}?v=${DateTime.now().millisecondsSinceEpoch}';

    await appState.atualizarProfilePicUrl(bustedUrl);

    // Se a UI estiver escutando esse ViewModel diretamente, isso aqui ajuda:
    notifyListeners();
  }
}

