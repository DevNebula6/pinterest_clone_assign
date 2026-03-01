import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.isActive,
    required this.onChanged,
    required this.onSubmitted,
    required this.onClear,
    required this.onActivate,
    required this.onCancel,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isActive;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onClear;
  final VoidCallback onActivate;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingLarge,
        vertical: AppDimensions.paddingSmall,
      ),
      child: Row(
        children: [
          Expanded(child: _buildField(context)),
          if (isActive) ...[
            const SizedBox(width: AppDimensions.paddingSmall),
            GestureDetector(
              onTap: onCancel,
              child: Text(
                'Cancel',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildField(BuildContext context) {
    return GestureDetector(
      onTap: isActive ? null : onActivate,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.lightGray,
          borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
        ),
        child: isActive ? _buildActiveField() : _buildInactiveField(),
      ),
    );
  }

  Widget _buildInactiveField() {
    return Row(
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 14, right: 8),
          child: Icon(
            Icons.search_rounded,
            size: AppDimensions.iconMedium,
            color: AppColors.textSecondary,
          ),
        ),
        Expanded(
          child: Text(
            'Search for ideas',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(right: 12),
          child: Icon(
            Icons.camera_alt_outlined,
            size: AppDimensions.iconSmall,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildActiveField() {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      autofocus: true,
      textInputAction: TextInputAction.search,
      style: AppTypography.bodyMedium,
      decoration: InputDecoration(
        hintText: 'Search for ideas',
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
        prefixIcon: const Icon(
          Icons.search_rounded,
          size: AppDimensions.iconMedium,
          color: AppColors.textSecondary,
        ),
        suffixIcon: controller.text.isNotEmpty
            ? GestureDetector(
                onTap: onClear,
                child: const Icon(
                  Icons.close_rounded,
                  size: AppDimensions.iconSmall,
                  color: AppColors.textSecondary,
                ),
              )
            : null,
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        isDense: true,
      ),
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );
  }
}
