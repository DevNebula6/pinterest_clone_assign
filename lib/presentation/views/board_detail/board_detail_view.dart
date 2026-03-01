import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../presentation/providers/board_providers.dart';
import 'widgets/board_header.dart';
import 'widgets/board_pins_grid.dart';

class BoardDetailView extends ConsumerWidget {
  const BoardDetailView({super.key, required this.boardId});

  final String boardId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boardState = ref.watch(boardNotifierProvider);

    if (boardState.isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        body: Center(child: LoadingWidget()),
      );
    }

    if (boardState.error != null) {
      return Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        appBar: AppBar(
          backgroundColor: AppColors.scaffoldBg,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
            onPressed: () => context.pop(),
          ),
        ),
        body: AppErrorWidget(
          message: 'Could not load board',
          onRetry: () => ref.read(boardNotifierProvider.notifier).loadBoards(),
        ),
      );
    }

    final boards = boardState.boards;
    final boardMatches = boards.where((b) => b.id == boardId).toList();

    if (boardMatches.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.scaffoldBg,
        appBar: AppBar(
          backgroundColor: AppColors.scaffoldBg,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
            onPressed: () => context.pop(),
          ),
        ),
        body: const AppErrorWidget(
          icon: Icons.dashboard_outlined,
          message: 'Board not found',
        ),
      );
    }

    final board = boardMatches.first;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: AppColors.scaffoldBg,
                elevation: 0,
                pinned: false,
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                  background: board.coverImageUrl != null
                      ? Image.network(
                          board.coverImageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                        )
                      : null,
                ),
                expandedHeight: board.coverImageUrl != null ? 200 : 0,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.ios_share, color: AppColors.textPrimary),
                    onPressed: () => Share.share('Check out my Pinterest board: ${board.name}'),
                  ),
                ],
              ),
              SliverToBoxAdapter(child: BoardHeader(board: board)),
              SliverToBoxAdapter(child: BoardPinsGrid(board: board)),
              const SliverToBoxAdapter(child: SizedBox(height: 80)),
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: AppDimensions.paddingMedium,
            child: FloatingActionButton.small(
              heroTag: 'board-back',
              backgroundColor: AppColors.white,
              elevation: 4,
              onPressed: () => context.pop(),
              child: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}

