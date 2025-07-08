import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:poupix/data/repositories/auth_repository.dart';
import 'package:poupix/ui/auth/view_models/loading_viewmodel.dart';
import 'package:poupix/ui/core/themes/dimens.dart';
import 'package:provider/provider.dart';

class Loading extends StatefulWidget {
  const Loading({super.key, required this.viewModel});
  final LoadingViewModel viewModel;

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  void initState() {
    super.initState();
    _verificarUsuario();
  }

  Future<void> _verificarUsuario() async {
    Future.delayed(Duration(seconds: 2));
    await widget.viewModel.carregarUsuario();

    final status = widget.viewModel.appState.usuario?.status ?? false;

    if (!mounted) return;

    if (status) {
      context.go('/home');
    } else {
      context.go('/verify');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: Dimens.of(context).edgeInsetsScreen,
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              InkWell(
                onTap: () async {
                  await context.read<AuthRepository>().logout();               
                  context.go('/login');
                },

                child: Text('Carregando...'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
