import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_typography.dart';
import 'pinterest_button.dart';

class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({
    super.key,
    this.message,
    this.subtitle,
    this.onRetry,
    this.icon = Icons.error_outline_rounded,
  });

  final String? message;
  final String? subtitle;
  final VoidCallback? onRetry;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.paddingXLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 56,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: AppDimensions.paddingMedium),
            Text(
              message ?? 'Something went wrong',
              style: AppTypography.h3.copyWith(color: AppColors.textPrimary),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: AppDimensions.paddingSmall),
              Text(
                subtitle!,
                style:
                    AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
            ],
            if (onRetry != null) ...[
              const SizedBox(height: AppDimensions.paddingXLarge),
              PinterestButton.secondary(
                label: 'Try again',
                onPressed: onRetry,
                isFullWidth: false,
                height: AppDimensions.buttonHeightSmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
