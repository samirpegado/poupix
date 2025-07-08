import 'package:flutter/material.dart';
import 'package:poupix/ui/add/view_models/add_viewmodel.dart';
import 'package:poupix/ui/components/navbar.dart';
import 'package:poupix/ui/core/themes/colors.dart';
import 'package:poupix/ui/core/themes/dimens.dart';
import 'package:poupix/ui/core/themes/theme.dart';

class Add extends StatefulWidget {
  const Add({super.key, required this.viewModel});
  final AddViewModel viewModel;

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Adicionar despesa',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
          backgroundColor: AppColors.black1,
        ),
        bottomNavigationBar: const MyBottomNavBar(
          route: '/add',
        ),
        body: Padding(
          padding: Dimens.of(context).edgeInsetsScreen,
          child: Column(children: []),
        ),
      ),
    );
  }
}
