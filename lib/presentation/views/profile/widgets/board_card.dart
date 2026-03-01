import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/shimmer_widget.dart';
import '../../../../domain/entities/board.dart';

class BoardCard extends StatelessWidget {
  const BoardCard({super.key, required this.board, required this.onTap});

  final Board board;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildThumbnail(),
          const SizedBox(height: 6),
          Text(
            board.name,
            style: AppTypography.labelMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            '${board.pinCount} pins',
            style: AppTypography.caption,
          ),
          const SizedBox(height: AppDimensions.paddingSmall),
        ],
      ),
    );
  }

  Widget _buildThumbnail() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
      child: AspectRatio(
        aspectRatio: 1.0,
        child: board.coverImageUrl != null && board.coverImageUrl!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: board.coverImageUrl!,
                fit: BoxFit.cover,
                // Board thumbnails are square ~150 px — 300 px is fine at 2x.
                memCacheWidth: 300,
                placeholder: (_, __) => const ShimmerWidget(
                  width: double.infinity,
                  height: double.infinity,
                ),
                errorWidget: (_, __, ___) => _buildColorFallback(),
              )
            : _buildColorFallback(),
      ),
    );
  }

  Widget _buildColorFallback() {
    final colorIndex = board.name.isNotEmpty
        ? board.name.codeUnitAt(0) % AppColors.boardColors.length
        : 0;
    return Container(
      color: AppColors.boardColors[colorIndex].withValues(alpha: 0.7),
      child: Center(
        child: Icon(
          Icons.grid_view_rounded,
          color: AppColors.white.withValues(alpha: 0.8),
          size: 36,
        ),
      ),
    );
  }
}
