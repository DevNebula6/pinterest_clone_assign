import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../domain/entities/board.dart';

class BoardHeader extends StatelessWidget {
  const BoardHeader({super.key, required this.board});

  final Board board;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.paddingLarge,
        AppDimensions.paddingMedium,
        AppDimensions.paddingLarge,
        AppDimensions.paddingLarge,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(board.name, style: AppTypography.h2),
          const SizedBox(height: 4),
          if (board.description != null && board.description!.isNotEmpty) ...[
            Text(
              board.description!,
              style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
          ],
          Text(
            '${board.pinCount} pins',
            style: AppTypography.caption,
          ),
        ],
      ),
    );
  }
}
