import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/board.dart';
import '../notifiers/board_notifier.dart';
import '../notifiers/board_state.dart';
import 'usecase_providers.dart';

final boardNotifierProvider =
    StateNotifierProvider<BoardNotifier, BoardState>((ref) {
  return BoardNotifier(
    getBoards: ref.watch(getBoardsProvider),
    createBoard: ref.watch(createBoardProvider),
    deleteBoard: ref.watch(deleteBoardProvider),
  );
});

// Convenience selectors
final boardsProvider = Provider<List<Board>>((ref) {
  return ref.watch(boardNotifierProvider).boards;
});

final isBoardLoadingProvider = Provider<bool>((ref) {
  return ref.watch(boardNotifierProvider).isLoading;
});
