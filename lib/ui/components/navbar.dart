import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:poupix/ui/core/themes/colors.dart';

class MyBottomNavBar extends StatelessWidget {
  final String route;
  const MyBottomNavBar({super.key, required this.route});

  static final tabs = [
    '/home',
    '/expenses',
    '/categories',
    '/profile',
  ];

  @override
  Widget build(BuildContext context) {
    int currentIndex = tabs.indexWhere((tab) => route.startsWith(tab));
    if (currentIndex == -1) currentIndex = 0;

    return SizedBox(
      height: 70,
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          if (route != tabs[index]) {
            context.go(tabs[index]);
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_rounded), label: 'Despesas'),
          BottomNavigationBarItem(
              icon: Icon(Icons.category), label: 'Categorias'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.secondaryColor,
      ),
    );
  }
}
