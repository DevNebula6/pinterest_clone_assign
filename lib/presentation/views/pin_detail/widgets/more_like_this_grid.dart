import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../domain/entities/pin.dart';
import '../../home/widgets/pin_card.dart';

class MoreLikeThisGrid extends StatelessWidget {
  const MoreLikeThisGrid({
    super.key,
    required this.pins,
    required this.isLoading,
    required this.savedPinIds,
    this.onSavePin,
  });

  final List<Pin> pins;
  final bool isLoading;
  final List<int> savedPinIds;
  final void Function(Pin pin)? onSavePin;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        if (isLoading && pins.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: LoadingWidget(),
          )
        else if (pins.isEmpty)
          _buildEmpty()
        else
          _buildGrid(context),
        if (isLoading && pins.isNotEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: LoadingWidget(),
          ),
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(
        AppDimensions.paddingLarge,
        AppDimensions.paddingLarge,
        AppDimensions.paddingLarge,
        AppDimensions.paddingMedium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(color: AppColors.divider),
          SizedBox(height: AppDimensions.paddingMedium),
          Text('More like this', style: AppTypography.h3),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return const Padding(
      padding: EdgeInsets.symmetric(
        vertical: 32,
        horizontal: AppDimensions.paddingLarge,
      ),
      child: Center(
        child: Text(
          'No related pins found',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.gridPadding,
      ),
      child: MasonryGridView.count(
        crossAxisCount: AppDimensions.gridColumnCount,
        crossAxisSpacing: AppDimensions.gridCrossAxisSpacing,
        mainAxisSpacing: AppDimensions.gridMainAxisSpacing,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: pins.length,
        itemBuilder: (context, index) {
          final pin = pins[index];
          return RepaintBoundary(
            child: PinCard(
              pin: pin,
              isSaved: savedPinIds.contains(pin.id),
              onSave: () => onSavePin?.call(pin),
              heroTagSuffix: 'related',
            ),
          );
        },
      ),
    );
  }
}
