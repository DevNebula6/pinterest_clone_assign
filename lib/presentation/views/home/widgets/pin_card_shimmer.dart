import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/widgets/shimmer_widget.dart';

class PinCardShimmer extends StatelessWidget {
  const PinCardShimmer({super.key});

  // Random-looking but deterministic heights for skeleton cards.
  static const List<double> _shimmerHeights = [
    180, 240, 200, 160, 280, 220, 150, 260, 190, 210,
    170, 250, 230, 185, 270, 145, 295, 205, 175, 255,
  ];

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.count(
      crossAxisCount: AppDimensions.gridColumnCount,
      crossAxisSpacing: AppDimensions.gridCrossAxisSpacing,
      mainAxisSpacing: AppDimensions.gridMainAxisSpacing,
      padding: const EdgeInsets.all(AppDimensions.gridPadding),
      itemCount: 20,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final height =
            _shimmerHeights[index % _shimmerHeights.length];
        return _ShimmerCard(imageHeight: height);
      },
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  const _ShimmerCard({required this.imageHeight});

  final double imageHeight;

  @override
  Widget build(BuildContext context) {
    final showMeta = Random(imageHeight.toInt()).nextBool();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerWidget(
          width: double.infinity,
          height: imageHeight,
          borderRadius: AppDimensions.pinCardBorderRadius,
        ),
        if (showMeta) ...[
          const SizedBox(height: 6),
          const ShimmerWidget(
            width: double.infinity,
            height: 12,
            borderRadius: AppDimensions.radiusSmall,
          ),
          const SizedBox(height: 4),
          const ShimmerWidget(
            width: 80,
            height: 10,
            borderRadius: AppDimensions.radiusSmall,
          ),
          const SizedBox(height: 4),
        ],
      ],
    );
  }
}

// A single shimmer card used at the bottom when loading more pins
class PinCardShimmerSmall extends StatelessWidget {
  const PinCardShimmerSmall({super.key, this.height = 180});

  final double height;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShimmerWidget(
          width: double.infinity,
          height: height,
          borderRadius: AppDimensions.pinCardBorderRadius,
        ),
        const SizedBox(height: 6),
        const ShimmerWidget(
          width: double.infinity,
          height: 12,
          borderRadius: AppDimensions.radiusSmall,
        ),
        const SizedBox(height: 4),
        const ShimmerWidget(
          width: 80,
          height: 10,
          borderRadius: AppDimensions.radiusSmall,
        ),
        const SizedBox(height: 4),
      ],
    );
  }
}
