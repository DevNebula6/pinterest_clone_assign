import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';

class PinActionBar extends StatelessWidget {
  const PinActionBar({
    super.key,
    required this.isSaved,
    required this.pageUrl,
    required this.onSave,
    required this.onShare,
  });

  final bool isSaved;
  final String pageUrl;
  final VoidCallback onSave;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    // Generate fake engagement numbers (deterministic from pageUrl hash)
    final hash = pageUrl.hashCode.abs();
    final likeCount = 50 + (hash % 500);
    final commentCount = 1 + (hash % 40);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingLarge,
        vertical: AppDimensions.paddingMedium,
      ),
      child: Row(
        children: [
          _IconWithCount(
            icon: Icons.favorite_border_rounded,
            count: likeCount,
            onTap: () => HapticFeedback.lightImpact(),
          ),
          const SizedBox(width: 16),
          _IconWithCount(
            icon: Icons.chat_bubble_outline_rounded,
            count: commentCount,
            onTap: () {},
          ),
          const SizedBox(width: 16),
          _ActionIcon(
            icon: Icons.share_outlined,
            onTap: onShare,
          ),
          const SizedBox(width: 16),
          _ActionIcon(
            icon: Icons.more_horiz,
            onTap: () => _copyLink(context, pageUrl),
          ),
          const Spacer(),
          _SaveButton(isSaved: isSaved, onTap: onSave),
        ],
      ),
    );
  }

  void _copyLink(BuildContext context, String url) {
    Clipboard.setData(ClipboardData(text: url));
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Link copied to clipboard'),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _IconWithCount extends StatelessWidget {
  const _IconWithCount({
    required this.icon,
    required this.count,
    required this.onTap,
  });

  final IconData icon;
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 22, color: AppColors.textPrimary),
          const SizedBox(width: 4),
          Text(
            count.toString(),
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  const _ActionIcon({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Icon(icon, size: 22, color: AppColors.textPrimary),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({required this.isSaved, required this.onTap});

  final bool isSaved;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        onTap();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: isSaved ? AppColors.textPrimary : AppColors.saveButtonRed,
          borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
        ),
        child: Text(
          isSaved ? 'Saved' : 'Save',
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}
