import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../domain/entities/board.dart';
import '../../../../presentation/providers/profile_providers.dart';
import '../../home/widgets/pin_card.dart';

class BoardPinsGrid extends ConsumerWidget {
  const BoardPinsGrid({super.key, required this.board});

  final Board board;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (board.pinIds.isEmpty) {
      return const SizedBox(
        height: 240,
        child: AppErrorWidget(
          icon: Icons.photo_library_outlined,
          message: 'No pins yet',
          subtitle: 'Save pins to this board to see them here.',
        ),
      );
    }

    // Get saved pins from profile state and filter to this board's pinIds
    final allSavedPins = ref.watch(profileSavedPinsProvider);
    final boardPins = allSavedPins
        .where((pin) => board.pinIds.contains(pin.id))
        .toList();

    if (boardPins.isEmpty) {
      return const SizedBox(
        height: 240,
        child: AppErrorWidget(
          icon: Icons.photo_library_outlined,
          message: 'No pins yet',
          subtitle: 'Save pins to this board to see them here.',
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
      itemCount: boardPins.length,
      itemBuilder: (context, index) {
        final pin = boardPins[index];
        return RepaintBoundary(
          child: PinCard(
            pin: pin,
            isSaved: true,
            heroTagSuffix: 'board',
          ),
        );
      },
    );
  }
}
