import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/pinterest_button.dart';
import '../../../providers/board_providers.dart';

class CreateBoardSheet extends ConsumerStatefulWidget {
  const CreateBoardSheet({super.key, required this.onDismiss});

  final VoidCallback onDismiss;

  @override
  ConsumerState<CreateBoardSheet> createState() => _CreateBoardSheetState();
}

class _CreateBoardSheetState extends ConsumerState<CreateBoardSheet> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  bool _isPrivate = false;
  bool _isCreating = false;

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _createBoard() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Board name cannot be empty'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    setState(() => _isCreating = true);
    await ref.read(boardNotifierProvider.notifier).createNewBoard(name);
    if (mounted) {
      setState(() => _isCreating = false);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Board "$name" created!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardPad = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusXLarge),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        AppDimensions.paddingLarge,
        AppDimensions.paddingMedium,
        AppDimensions.paddingLarge,
        AppDimensions.paddingLarge + keyboardPad,
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppDimensions.paddingMedium),
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
                ),
              ),
            ),
            Row(
              children: [
                const Text('Create board', style: AppTypography.h3),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.textPrimary),
                  onPressed: widget.onDismiss,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.paddingLarge),
            TextField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              style: AppTypography.bodyMedium,
              decoration: InputDecoration(
                hintText: 'Board name',
                hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                filled: true,
                fillColor: AppColors.lightGray,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingMedium,
                  vertical: AppDimensions.paddingMedium,
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.paddingMedium),
            TextField(
              controller: _descController,
              textCapitalization: TextCapitalization.sentences,
              style: AppTypography.bodyMedium,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'Description (optional)',
                hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                filled: true,
                fillColor: AppColors.lightGray,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingMedium,
                  vertical: AppDimensions.paddingMedium,
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.paddingMedium),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Keep this board secret', style: AppTypography.labelSmall),
              subtitle: Text(
                'Only you can see it',
                style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
              ),
              value: _isPrivate,
              activeThumbColor: AppColors.pinterestRed,
              onChanged: (val) => setState(() => _isPrivate = val),
            ),
            const SizedBox(height: AppDimensions.paddingLarge),
            PinterestButton(
              onPressed: _isCreating ? null : _createBoard,
              label: 'Create',
              isLoading: _isCreating,
            ),
          ],
        ),
      ),
    );
  }
}
