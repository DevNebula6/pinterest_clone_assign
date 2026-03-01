import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';

class ProfileStats extends StatelessWidget {
  const ProfileStats({
    super.key,
    required this.followersCount,
    required this.followingCount,
    this.pinsCount = 0,
  });

  final int followersCount;
  final int followingCount;
  final int pinsCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppDimensions.paddingMedium),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _StatItem(label: 'Pins', count: pinsCount),
          _Divider(),
          _StatItem(label: 'Followers', count: followersCount),
          _Divider(),
          _StatItem(label: 'Following', count: followingCount),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.label, required this.count});

  final String label;
  final int count;

  String get _displayCount {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return count.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingLarge),
      child: Column(
        children: [
          Text(_displayCount, style: AppTypography.labelLarge),
          const SizedBox(height: 2),
          Text(label, style: AppTypography.caption),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 28,
      color: AppColors.divider,
    );
  }
}
