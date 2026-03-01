import 'package:flutter/material.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/avatar_widget.dart';

class PinCreatorRow extends StatelessWidget {
  const PinCreatorRow({
    super.key,
    required this.photographerName,
    this.photographerUrl,
  });

  final String photographerName;
  final String? photographerUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingLarge,
        vertical: AppDimensions.paddingSmall,
      ),
      child: Row(
        children: [
          AvatarWidget(
            size: 28,
            name: photographerName,
          ),
          const SizedBox(width: AppDimensions.paddingSmall),
          Text(
            photographerName,
            style: AppTypography.labelMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
