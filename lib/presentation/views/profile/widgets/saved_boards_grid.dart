import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../presentation/providers/profile_providers.dart';
import 'board_card.dart';

// shows boards in a 2-column grid
class SavedBoardsGrid extends ConsumerWidget {
  const SavedBoardsGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileNotifierProvider);

    if (profileState.isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: LoadingWidget(),
      );
    }

    if (profileState.boards.isEmpty) {
      return const SizedBox(
        height: 200,
        child: AppErrorWidget(
          icon: Icons.dashboard_outlined,
          message: 'No boards yet',
          subtitle: 'Create a board to organize your saved pins.',
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(AppDimensions.paddingLarge),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: AppDimensions.gridCrossAxisSpacing,
          mainAxisSpacing: AppDimensions.gridMainAxisSpacing,
          childAspectRatio: 0.75,
        ),
        itemCount: profileState.boards.length,
        itemBuilder: (context, index) {
          final board = profileState.boards[index];
          return BoardCard(
            board: board,
            onTap: () => context.push('/profile/board/${board.id}'),
          );
        },
      ),
    );
  }
}
