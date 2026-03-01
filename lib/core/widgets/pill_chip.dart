import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_typography.dart';

class PillChip extends StatelessWidget {
  const PillChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.leadingIcon,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Widget? leadingIcon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingMedium,
          vertical: AppDimensions.paddingXSmall + 2,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.textPrimary : AppColors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
          border: Border.all(
            color: isSelected ? AppColors.textPrimary : AppColors.divider,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (leadingIcon != null) ...[
              IconTheme(
                data: IconThemeData(
                  color: isSelected ? AppColors.white : AppColors.textPrimary,
                  size: AppDimensions.iconSmall,
                ),
                child: leadingIcon!,
              ),
              const SizedBox(width: AppDimensions.paddingXSmall),
            ],
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                color: isSelected ? AppColors.white : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
