import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/avatar_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../domain/entities/board.dart';
import '../../../../domain/entities/pin.dart';
import '../../../providers/board_providers.dart';
import '../../../providers/home_providers.dart';
import '../../../providers/pin_detail_providers.dart';
import '../../../providers/profile_providers.dart';
import '../../../providers/usecase_providers.dart';

class SaveToBoardSheet extends ConsumerStatefulWidget {
  const SaveToBoardSheet({super.key, required this.pinId, this.pin});

  final int pinId;

  // if pin is passed in, we save directly without needing the detail notifier
  // this is handy when opening the sheet from the home feed
  final Pin? pin;

  @override
  ConsumerState<SaveToBoardSheet> createState() => _SaveToBoardSheetState();
}

class _SaveToBoardSheetState extends ConsumerState<SaveToBoardSheet> {
  String? _savingBoardId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(boardNotifierProvider.notifier).loadBoards();
    });
  }

  @override
  Widget build(BuildContext context) {
    final boardState = ref.watch(boardNotifierProvider);

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusXLarge),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHandle(),
          _buildHeader(),
          const Divider(height: 1, color: AppColors.divider),
          Flexible(
            child: boardState.isLoading
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: LoadingWidget(),
                  )
                : _buildBoardList(boardState.boards),
          ),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      width: 36,
      height: 4,
      margin: const EdgeInsets.only(top: 12, bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.divider,
        borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.paddingLarge,
        4,
        AppDimensions.paddingLarge,
        AppDimensions.paddingMedium,
      ),
      child: Row(
        children: [
          const Spacer(),
          const Text('Save to board', style: AppTypography.h3),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.textPrimary),
            onPressed: () => Navigator.pop(context),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
          ),
        ],
      ),
    );
  }

  Widget _buildBoardList(List<Board> boards) {
    return ListView.builder(
      shrinkWrap: true,
      padding: const EdgeInsets.only(bottom: AppDimensions.paddingXLarge),
      itemCount: boards.length + 1, // +1 for "Create board" option
      itemBuilder: (context, index) {
        if (index == 0) return _buildCreateBoardTile();
        return _buildBoardTile(boards[index - 1]);
      },
    );
  }

  Widget _buildCreateBoardTile() {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingLarge,
        vertical: AppDimensions.paddingXSmall,
      ),
      leading: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: AppColors.lightGray,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          border: Border.all(
            color: AppColors.divider,
            width: 1.5,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        child: const Icon(
          Icons.add_rounded,
          color: AppColors.textPrimary,
          size: AppDimensions.iconMedium,
        ),
      ),
      title: const Text('Create board', style: AppTypography.labelMedium),
      onTap: () => _showCreateBoardDialog(),
    );
  }

  Widget _buildBoardTile(Board board) {
    final isSaving = _savingBoardId == board.id;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingLarge,
        vertical: AppDimensions.paddingXSmall,
      ),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        child: board.coverImageUrl != null && board.coverImageUrl!.isNotEmpty
            ? Image.network(
                board.coverImageUrl!,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _BoardPlaceholder(name: board.name),
              )
            : _BoardPlaceholder(name: board.name),
      ),
      title: Text(board.name, style: AppTypography.labelMedium),
      subtitle: Text(
        '${board.pinCount} pins',
        style: AppTypography.caption,
      ),
      trailing: isSaving
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.pinterestRed,
              ),
            )
          : null,
      onTap: isSaving ? null : () => _saveToBoard(board),
    );
  }

  Future<void> _saveToBoard(Board board) async {
    setState(() => _savingBoardId = board.id);

    bool success;
    if (widget.pin != null) {
      // Direct save via use case (used from home feed / related pins)
      final result = await ref
          .read(savePinToBoardProvider)
          .call(board.id, widget.pin!);
      success = result.fold((_) => false, (_) => true);
    } else {
      // Save through pin detail notifier (used from pin detail view)
      success = await ref
          .read(pinDetailNotifierProvider(widget.pinId).notifier)
          .savePin(board.id);
    }

    // Refresh all relevant providers so UI stays in sync
    ref.read(homeFeedNotifierProvider.notifier).refreshSavedPinIds();
    ref.read(boardNotifierProvider.notifier).loadBoards();
    ref.read(profileNotifierProvider.notifier).refreshProfile();

    if (!mounted) return;

    setState(() => _savingBoardId = null);
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success ? 'Saved to ${board.name}!' : 'Could not save. Try again.',
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        backgroundColor:
            success ? AppColors.textPrimary : AppColors.pinterestRed,
      ),
    );
  }

  void _showCreateBoardDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
          ),
          title: const Text('Create Board'),
          content: TextField(
            controller: controller,
            autofocus: true,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              hintText: 'Board name',
              hintStyle:
                  AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
              filled: true,
              fillColor: AppColors.lightGray,
              border: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusMedium),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'Cancel',
                style: AppTypography.labelSmall
                    .copyWith(color: AppColors.textSecondary),
              ),
            ),
            TextButton(
              onPressed: () async {
                final name = controller.text.trim();
                Navigator.pop(dialogContext);
                if (name.isEmpty) return;
                final board = await ref
                    .read(boardNotifierProvider.notifier)
                    .createNewBoard(name);
                if (board != null && mounted) {
                  _saveToBoard(board);
                }
              },
              child: Text(
                'Create',
                style: AppTypography.labelSmall
                    .copyWith(color: AppColors.pinterestRed),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _BoardPlaceholder extends StatelessWidget {
  const _BoardPlaceholder({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return AvatarWidget(
      size: 56,
      name: name,
    );
  }
}
