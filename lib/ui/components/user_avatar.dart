import 'package:flutter/material.dart';
import 'package:poupix/ui/core/themes/colors.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({super.key, this.size = 40});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.black1, AppColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.person_outline,
        size: size * 0.55,
        color: Colors.white,
      ),
    );
  }
}
