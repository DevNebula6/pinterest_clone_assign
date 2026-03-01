import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/cached_image_widget.dart';
import '../../../../core/widgets/scale_tap.dart';
import '../../../../domain/entities/pin.dart';

class PinCard extends StatelessWidget {
  const PinCard({
    super.key,
    required this.pin,
    this.isSaved = false,
    this.onSave,
    this.heroTagSuffix = '',
  });

  final Pin pin;
  final bool isSaved;
  final VoidCallback? onSave;
  // Suffix lets us disambiguate hero tags when the same pin appears
  // in two branches (e.g. home and search).
  final String heroTagSuffix;

  String get _heroTag => 'pin-${pin.id}-$heroTagSuffix';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => _onLongPress(context),
      child: ScaleTap(
        onPressed: () => _onTap(context),
        scaleTo: 0.97,
        enableHaptic: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = constraints.maxWidth;
            return _buildCard(context, cardWidth);
          },
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, double cardWidth) {
    // Clamp aspect ratio so neither tiny nor huge images break the grid.
    final aspectRatio =
        pin.height == 0 ? 1.0 : pin.width / pin.height;
    final clampedRatio = aspectRatio.clamp(0.45, 2.0);
    final imageHeight = cardWidth / clampedRatio;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildImage(cardWidth, imageHeight),
        _buildThreeDotsMenu(context),
      ],
    );
  }

  Widget _buildImage(double width, double height) {
    return CachedImageWidget(
      imageUrl: pin.thumbnailUrl,
      width: width,
      height: height,
      borderRadius: AppDimensions.pinCardBorderRadius,
      avgColor: pin.avgColor,
      heroTag: _heroTag,
      // Grid columns are ~168 logical px; at 3x density that's ~500 physical px.
      // Using 700 keeps images sharp on high-density screens.
      memCacheWidth: 700,
    );
  }

  Widget _buildThreeDotsMenu(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () => _showQuickActionsSheet(context),
        behavior: HitTestBehavior.opaque,
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Icon(
            Icons.more_horiz,
            size: 20,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  void _onTap(BuildContext context) {
    context.push('/pin/${pin.id}');
  }

  void _onLongPress(BuildContext context) {
    HapticFeedback.mediumImpact();
    _showQuickActionsSheet(context);
  }

  void _showQuickActionsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusXLarge),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(top: 12, bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius:
                      BorderRadius.circular(AppDimensions.radiusRound),
                ),
              ),
              if (pin.alt.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingXLarge,
                  ),
                  child: Text(
                    pin.alt,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: AppTypography.labelMedium,
                  ),
                ),
              const SizedBox(height: 16),
              _SheetAction(
                icon: isSaved
                    ? Icons.bookmark_rounded
                    : Icons.bookmark_border_rounded,
                label: isSaved ? 'Saved' : 'Save Pin',
                color: AppColors.pinterestRed,
                onTap: () {
                  Navigator.pop(sheetContext);
                  onSave?.call();
                },
              ),
              _SheetAction(
                icon: Icons.open_in_new_rounded,
                label: 'View Pin',
                color: AppColors.textPrimary,
                onTap: () {
                  Navigator.pop(sheetContext);
                  context.push('/pin/${pin.id}');
                },
              ),
              _SheetAction(
                icon: Icons.share_rounded,
                label: 'Share',
                color: AppColors.textPrimary,
                onTap: () => Navigator.pop(sheetContext),
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}

class _SheetAction extends StatelessWidget {
  const _SheetAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: color, size: AppDimensions.iconMedium),
      title: Text(
        label,
        style: AppTypography.bodyMedium.copyWith(color: color),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingXLarge,
      ),
    );
  }
}
