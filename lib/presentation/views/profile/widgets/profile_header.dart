import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/avatar_widget.dart';
import '../../../../domain/entities/user.dart';
import 'profile_stats.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.user,
    required this.pinsCount,
    this.onEditProfile,
    this.onShare,
  });

  final User user;
  final int pinsCount;
  final VoidCallback? onEditProfile;
  final VoidCallback? onShare;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: AppDimensions.paddingXLarge),
        AvatarWidget(
          size: AppDimensions.avatarLarge,
          imageUrl: user.avatarUrl,
          name: user.name ?? user.username ?? 'User',
        ),
        const SizedBox(height: AppDimensions.paddingMedium),
        Text(
          user.name ?? user.username ?? 'User',
          style: AppTypography.h2,
          textAlign: TextAlign.center,
        ),
        if (user.username != null) ...[
          const SizedBox(height: 2),
          Text(
            '@${user.username}',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
        ],
        ProfileStats(
          followersCount: user.followersCount,
          followingCount: user.followingCount,
          pinsCount: pinsCount,
        ),
        _buildActionButtons(),
        const SizedBox(height: AppDimensions.paddingMedium),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onShare,
          child: Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: AppColors.buttonGray,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.share_rounded,
              size: AppDimensions.iconSmall,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        const SizedBox(width: AppDimensions.paddingSmall),
        GestureDetector(
          onTap: onEditProfile,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingXLarge,
              vertical: 11,
            ),
            decoration: BoxDecoration(
              color: AppColors.buttonGray,
              borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
            ),
            child: Text(
              'Edit profile',
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppDimensions.paddingSmall),
        Container(
          width: 44,
          height: 44,
          decoration: const BoxDecoration(
            color: AppColors.buttonGray,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.more_horiz_rounded,
            size: AppDimensions.iconSmall,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
