import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:poupix/app_state/app_state.dart';
import 'package:poupix/data/repositories/auth_repository.dart';
import 'package:poupix/data/services/summary_notification_service.dart';
import 'package:poupix/ui/components/manage_account.dart';
import 'package:poupix/ui/components/navbar.dart';
import 'package:poupix/ui/core/themes/colors.dart';
import 'package:poupix/ui/core/themes/dimens.dart';
import 'package:poupix/ui/core/themes/theme.dart';
import 'package:poupix/ui/profile/widgets/profile_option.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Perfil',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
        ),
        bottomNavigationBar: const MyBottomNavBar(route: '/profile'),
        body: SingleChildScrollView(
          padding: Dimens.of(context).edgeInsetsScreen,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 28),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.black1, AppColors.primary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Text(
                      appState.usuario?.nome ?? 'Usuário',
                      style: AppTheme.lightTheme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      appState.usuario?.email ?? '',
                      style: AppTheme.lightTheme.textTheme.titleSmall
                          ?.copyWith(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const _NotificationPreferenceTile(),
              const SizedBox(height: 12),
              ProfileOption(
                action: () => context.push('/donate'),
                icone: const Icon(
                  Icons.volunteer_activism_outlined,
                  color: AppColors.primary,
                  size: 24,
                ),
                label: 'Apoie o projeto',
              ),
              const SizedBox(height: 12),
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
                        child: ManageAccount(),
                      );
                    },
                  );
                },
                icone: const Icon(
                  Icons.edit_square,
                  color: AppColors.secondaryColor,
                  size: 24,
                ),
                label: 'Gerenciar conta',
              ),
              const SizedBox(height: 12),
              ProfileOption(
                action: () => context.push('/change-password'),
                icone: const Icon(
                  Icons.password_outlined,
                  color: AppColors.secondaryColor,
                  size: 24,
                ),
                label: 'Alterar senha',
              ),
              const SizedBox(height: 12),
              ProfileOption(
                action: () => context.push('/policy'),
                icone: const Icon(
                  Icons.document_scanner,
                  color: AppColors.secondaryColor,
                  size: 24,
                ),
                label: 'Termos de uso',
              ),
              const SizedBox(height: 12),
              ProfileOption(
                labelColor: AppColors.red1,
                action: () async {
                  await appState.logout();
                  await context.read<AuthRepository>().logout();
                },
                icone: const Icon(
                  Icons.logout_rounded,
                  color: AppColors.red1,
                  size: 24,
                ),
                label: 'Sair',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationPreferenceTile extends StatefulWidget {
  const _NotificationPreferenceTile();

  @override
  State<_NotificationPreferenceTile> createState() =>
      _NotificationPreferenceTileState();
}

class _NotificationPreferenceTileState extends State<_NotificationPreferenceTile> {
  bool _enabled = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final enabled = await SummaryNotificationService.instance.isEnabled();
    if (mounted) {
      setState(() {
        _enabled = enabled;
        _loading = false;
      });
    }
  }

  Future<void> _toggle(bool value) async {
    setState(() => _enabled = value);
    await SummaryNotificationService.instance.setEnabled(value);

    if (value && mounted) {
      final appState = context.read<AppState>();
      final despesas = appState.despesasMes;
      if (despesas != null) {
        await SummaryNotificationService.instance.updateMonthlySummary(
          mesReferencia: appState.dataSelecionada ?? DateTime.now(),
          totalPendente: despesas.totalPendente,
          qtdPendentes:
              despesas.despesas.where((d) => !d.liquidada).length,
          qtdTotal: despesas.despesas.length,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: AppTheme.cardDecoration,
      child: SwitchListTile(
        contentPadding: EdgeInsets.zero,
        secondary: const Icon(
          Icons.notifications_outlined,
          color: AppColors.primary,
        ),
        title: const Text('Resumo diário'),
        subtitle: const Text(
          'Notificação às 8h30 com despesas pendentes do mês',
          style: TextStyle(fontSize: 12),
        ),
        value: _enabled,
        onChanged: _loading ? null : _toggle,
      ),
    );
  }
}
