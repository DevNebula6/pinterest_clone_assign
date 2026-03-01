import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../presentation/providers/profile_providers.dart';
import '../../home/widgets/pin_card.dart';
import '../../home/widgets/pin_card_shimmer.dart';

// shows saved pins in the masonry grid layout
class CreatedPinsGrid extends ConsumerWidget {
  const CreatedPinsGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileNotifierProvider);

    if (profileState.isLoading) {
      return const PinCardShimmer();
    }

    if (profileState.savedPins.isEmpty) {
      return const SizedBox(
        height: 200,
        child: AppErrorWidget(
          icon: Icons.bookmark_border_rounded,
          message: 'No saved pins yet',
          subtitle: 'Save pins from the home feed to see them here.',
        ),
      );
    }

    return MasonryGridView.count(
      crossAxisCount: AppDimensions.gridColumnCount,
      crossAxisSpacing: AppDimensions.gridCrossAxisSpacing,
      mainAxisSpacing: AppDimensions.gridMainAxisSpacing,
      padding: const EdgeInsets.all(AppDimensions.gridPadding),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: profileState.savedPins.length,
      itemBuilder: (context, index) {
        final pin = profileState.savedPins[index];
        return RepaintBoundary(
          child: PinCard(
            pin: pin,
            isSaved: true,
            heroTagSuffix: 'saved',
          ),
        );
      },
    );
  }
}
