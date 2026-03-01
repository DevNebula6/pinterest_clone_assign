import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.timeAgo,
    this.imageUrl,
    this.isRead = false,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final String timeAgo;
  final String? imageUrl;
  final bool isRead;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isRead ? AppColors.scaffoldBg : const Color(0xFFFFF0F0),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingLarge,
          vertical: AppDimensions.paddingSmall,
        ),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: iconBg,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: iconColor, size: AppDimensions.iconSmall),
        ),
        title: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: title,
                style: AppTypography.labelSmall,
              ),
              TextSpan(
                text: ' $subtitle',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 2),
          child: Text(timeAgo, style: AppTypography.caption),
        ),
        trailing: imageUrl != null
            ? ClipRRect(
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusSmall),
                child: Image.network(
                  imageUrl!,
                  width: 48,
                  height: 48,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              )
            : !isRead
                ? Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.pinterestRed,
                      shape: BoxShape.circle,
                    ),
                  )
                : null,
      ),
    );
  }
}
