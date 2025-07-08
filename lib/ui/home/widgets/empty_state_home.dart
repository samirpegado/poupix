import 'package:flutter/material.dart';
import 'package:poupix/ui/core/themes/colors.dart';
import 'package:shimmer/shimmer.dart';

class EmptyStateHome extends StatelessWidget {
  const EmptyStateHome({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          shimmerBox(height: 110),
          SizedBox(height: 16),
          shimmerBox(height: 500),
          SizedBox(height: 16),
          shimmerBox(height: 200),
        ],
      ),
    );
  }

  Widget shimmerBox({required double height}) {
    return Shimmer.fromColors(
      baseColor: AppColors.grey1,
      highlightColor: AppColors.grey3,
      period: Duration(milliseconds: 500),
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.grey1,
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}
