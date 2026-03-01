import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/avatar_widget.dart';

class PinCommentsSection extends StatelessWidget {
  const PinCommentsSection({super.key, required this.authorName});

  final String authorName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingLarge,
        vertical: AppDimensions.paddingMedium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Comments', style: AppTypography.h3),
          const SizedBox(height: AppDimensions.paddingMedium),
          _buildCommentInput(context),
          const SizedBox(height: AppDimensions.paddingMedium),
          _buildPlaceholderComment(
            name: 'Alex Rivera',
            text: 'Absolutely stunning! The colors are incredible 🔥',
            timeAgo: '2h',
          ),
          const SizedBox(height: AppDimensions.paddingMedium),
          _buildPlaceholderComment(
            name: 'Sam Chen',
            text: 'Love this aesthetic. Saving for my mood board!',
            timeAgo: '5h',
          ),
          const SizedBox(height: AppDimensions.paddingSmall),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'View all 24 comments',
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentInput(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Visual-only — tap shows a stub snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Comments coming soon!'),
            duration: Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: Row(
        children: [
          AvatarWidget(size: 36, name: authorName),
          const SizedBox(width: AppDimensions.paddingMedium),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingLarge,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: AppColors.lightGray,
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusRound),
              ),
              child: Text(
                'What do you think?',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderComment({
    required String name,
    required String text,
    required String timeAgo,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AvatarWidget(size: 36, name: name),
        const SizedBox(width: AppDimensions.paddingMedium),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(name, style: AppTypography.labelSmall),
                  const SizedBox(width: AppDimensions.paddingSmall),
                  Text(timeAgo, style: AppTypography.caption),
                ],
              ),
              const SizedBox(height: 2),
              Text(text, style: AppTypography.bodySmall),
            ],
          ),
        ),
        const SizedBox(width: AppDimensions.paddingSmall),
        const Icon(
          Icons.favorite_border_rounded,
          size: AppDimensions.iconSmall,
          color: AppColors.textTertiary,
        ),
      ],
    );
  }
}
