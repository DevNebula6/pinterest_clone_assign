import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({
    super.key,
    required this.onTap,
    required this.label,
    this.iconAsset,
    this.iconWidget,
    this.isLoading = false,
  });

  final VoidCallback onTap;
  final String label;
  final String? iconAsset;
  final Widget? iconWidget;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
            border: Border.all(color: AppColors.divider, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isLoading)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else ...[
                if (iconWidget != null) ...[
                  iconWidget!,
                  const SizedBox(width: AppDimensions.paddingSmall),
                ] else if (iconAsset != null) ...[
                  Image.asset(iconAsset!, width: 22, height: 22),
                  const SizedBox(width: AppDimensions.paddingSmall),
                ],
                Text(label, style: AppTypography.labelMedium),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
