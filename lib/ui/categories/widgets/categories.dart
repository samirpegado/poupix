import 'package:flutter/material.dart';
import 'package:poupix/ui/categories/view_models/categories_viewmodel.dart';
import 'package:poupix/ui/components/navbar.dart';
import 'package:poupix/ui/core/themes/colors.dart';
import 'package:poupix/ui/core/themes/dimens.dart';
import 'package:poupix/ui/core/themes/theme.dart';

class Categories extends StatefulWidget {
  const Categories({super.key, required this.viewModel});
  final CategoriesViewModel viewModel;

  @override
  State<Categories> createState() => _CategoriesState();
}



class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Categorias',
            style: AppTheme.lightTheme.textTheme.titleMedium,
          ),
          backgroundColor: AppColors.black1,
        ),
        bottomNavigationBar: const MyBottomNavBar(route: '/categories',),
        body: Padding(
          padding: Dimens.of(context).edgeInsetsScreen,
          child: Column(children: []),
        ),
      ),
    );
  }
}
