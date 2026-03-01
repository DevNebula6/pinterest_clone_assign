import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import 'create_board_sheet.dart';

class CreateOptionSheet extends StatelessWidget {
  const CreateOptionSheet({super.key, required this.onDismiss});

  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusXLarge),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.paddingLarge,
                AppDimensions.paddingSmall,
                AppDimensions.paddingLarge,
                AppDimensions.paddingMedium,
              ),
              child: Row(
                children: [
                  const Text('Create', style: AppTypography.h3),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: AppColors.textPrimary),
                    onPressed: onDismiss,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                  ),
                ],
              ),
            ),
            _CreateOption(
              icon: Icons.add_photo_alternate_outlined,
              label: 'Pin',
              subtitle: 'Save a photo or video',
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Image picker coming soon!'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
            _CreateOption(
              icon: Icons.camera_alt_outlined,
              label: 'Take Photo',
              subtitle: 'Use your camera',
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Camera coming soon!'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
            _CreateOption(
              icon: Icons.dashboard_outlined,
              label: 'Board',
              subtitle: 'Organize your ideas',
              onTap: () {
                Navigator.pop(context);
                _showCreateBoardSheet(context);
              },
            ),
            const SizedBox(height: AppDimensions.paddingLarge),
          ],
        ),
      ),
    );
  }

  void _showCreateBoardSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CreateBoardSheet(onDismiss: () => Navigator.pop(context)),
    );
  }
}

class _CreateOption extends StatelessWidget {
  const _CreateOption({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingXLarge,
        vertical: AppDimensions.paddingXSmall,
      ),
      leading: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.lightGray,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        ),
        child: Icon(icon, color: AppColors.textPrimary, size: AppDimensions.iconMedium),
      ),
      title: Text(label, style: AppTypography.labelMedium),
      subtitle: Text(subtitle, style: AppTypography.caption),
      onTap: onTap,
    );
  }
}
