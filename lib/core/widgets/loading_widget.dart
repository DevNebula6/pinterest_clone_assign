import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key, this.size = 28.0});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: const CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.pinterestRed),
        ),
      ),
    );
  }
}
