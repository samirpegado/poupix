import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:poupix/app_state/app_state.dart';
import 'package:poupix/data/repositories/auth_repository.dart';
import 'package:poupix/ui/components/manage_account.dart';
import 'package:poupix/ui/components/navbar.dart';
import 'package:poupix/ui/core/themes/colors.dart';
import 'package:poupix/ui/core/themes/dimens.dart';
import 'package:poupix/ui/core/themes/theme.dart';
import 'package:poupix/ui/profile/view_models/profile_viewmodel.dart';
import 'package:poupix/ui/profile/widgets/profile_option.dart';
import 'package:poupix/utils/functions.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key, required this.viewModel});
  final ProfileViewModel viewModel;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final usuario = context.watch<AppState>().usuario;
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Perfil',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
          backgroundColor: AppColors.black1,
        ),
        bottomNavigationBar: const MyBottomNavBar(
          route: '/profile',
        ),
        body: Padding(
          padding: Dimens.of(context).edgeInsetsScreen,
          child: Column(children: [
            ClipOval(
              child: Image.network(
                usuario?.profilePic ??
                    'https://storage.googleapis.com/flutterflow-io-6f20.appspot.com/projects/contas-bq58qy/assets/b0smeq7opmcb/emptyUser_(1).png',
                fit: BoxFit.cover,
                width: 100,
                height: 100,
              ),
            ),
            SizedBox(height: 16),
            Text(
              usuario?.nome ?? 'userName',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 8),
            Text(
              usuario?.email ?? 'email@exemple.com',
              style: AppTheme.lightTheme.textTheme.bodySmall,
            ),
            SizedBox(height: 20),
            ProfileOption(
              action: () => context.go('/donate'),
              icone: Icon(
                Icons.coffee,
                color: AppColors.secondaryText,
                size: 24,
              ),
              label: 'Buy me a coffee',
            ),
            SizedBox(height: 16),
            ProfileOption(
              action: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                        insetPadding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ManageAccount());
                  },
                );
              },
              icone: Icon(
                Icons.edit_square,
                color: AppColors.secondaryColor,
                size: 24,
              ),
              label: 'Gerir conta',
            ),
            SizedBox(height: 16),
            ProfileOption(
              icone: Icon(
                Icons.password_outlined,
                color: AppColors.secondaryColor,
                size: 24,
              ),
              label: 'Alterar senha',
            ),
            SizedBox(height: 16),
            ProfileOption(
              action: () => selecionarImagem(context),
              icone: Icon(
                Icons.image,
                color: AppColors.secondaryColor,
                size: 24,
              ),
              label: 'Alterar foto',
            ),
            SizedBox(height: 16),
            ProfileOption(
              labelColor: AppColors.red1,
              action: () async {
                await context.read<AppState>().logout();
                await context.read<AuthRepository>().logout();
              },
              icone: Icon(
                Icons.logout_rounded,
                color: AppColors.red1,
                size: 24,
              ),
              label: 'Sair',
            ),
          ]),
        ),
      ),
    );
  }
}
