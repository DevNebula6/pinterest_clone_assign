import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';

class PinDescription extends StatefulWidget {
  const PinDescription({
    super.key,
    required this.alt,
    required this.photographerName,
    required this.photographerUrl,
  });

  final String alt;
  final String photographerName;
  final String photographerUrl;

  @override
  State<PinDescription> createState() => _PinDescriptionState();
}

class _PinDescriptionState extends State<PinDescription> {
  bool _expanded = false;

  // Pexels alt text can be quite long – show first 120 chars then expand.
  static const int _truncateAt = 120;

  String get _displayText =>
      widget.alt.isNotEmpty ? widget.alt : 'Photo by ${widget.photographerName}';

  bool get _needsTruncation => _displayText.length > _truncateAt;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingLarge,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(),
          const SizedBox(height: AppDimensions.paddingSmall),
          _buildDescription(),
          const SizedBox(height: AppDimensions.paddingSmall),
          _buildAttribution(),
          const SizedBox(height: AppDimensions.paddingLarge),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    final title = widget.alt.isNotEmpty
        ? widget.alt.split('.').first.trim()
        : 'Untitled';

    return Text(
      title,
      style: AppTypography.h2,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildDescription() {
    if (!_needsTruncation || _expanded) {
      return Text(
        _displayText,
        style: AppTypography.bodyMedium,
      );
    }

    return GestureDetector(
      onTap: () => setState(() => _expanded = true),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '${_displayText.substring(0, _truncateAt)}... ',
              style: AppTypography.bodyMedium,
            ),
            TextSpan(
              text: 'more',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttribution() {
    return Row(
      children: [
        const Icon(
          Icons.photo_camera_outlined,
          size: 14,
          color: AppColors.textSecondary,
        ),
        const SizedBox(width: 4),
        const Text(
          'Photo by ',
          style: AppTypography.caption,
        ),
        Text(
          widget.photographerName,
          style: AppTypography.caption.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            decoration: TextDecoration.underline,
          ),
        ),
        const Text(
          ' on Pexels',
          style: AppTypography.caption,
        ),
      ],
    );
  }
}
