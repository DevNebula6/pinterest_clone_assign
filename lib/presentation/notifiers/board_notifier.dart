import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/board.dart';
import '../../domain/usecases/get_boards.dart';
import '../../domain/usecases/create_board.dart';
import '../../domain/usecases/delete_board.dart';
import 'board_state.dart';

class BoardNotifier extends StateNotifier<BoardState> {
  BoardNotifier({
    required this.getBoards,
    required this.createBoard,
    required this.deleteBoard,
  }) : super(const BoardState());

  final GetBoards getBoards;
  final CreateBoard createBoard;
  final DeleteBoard deleteBoard;

  Future<void> loadBoards() async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await getBoards();

    if (!mounted) return;

    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure);
      },
      (boards) {
        state = state.copyWith(boards: boards, isLoading: false, clearError: true);
      },
    );
  }

  Future<Board?> createNewBoard(String name, {String? description, bool isPrivate = false}) async {
    final result = await createBoard(name, description: description, isPrivate: isPrivate);
    return result.fold(
      (failure) {
        state = state.copyWith(error: failure);
        return null;
      },
      (board) {
        state = state.copyWith(boards: [...state.boards, board]);
        return board;
      },
    );
  }

  Future<bool> removeBoardById(String boardId) async {
    final result = await deleteBoard(boardId);
    return result.fold(
      (failure) {
        state = state.copyWith(error: failure);
        return false;
      },
      (_) {
        final updated = state.boards.where((b) => b.id != boardId).toList();
        state = state.copyWith(boards: updated);
        return true;
      },
    );
  }

  void updateBoardInList(Board updatedBoard) {
    final updated = state.boards.map((b) {
      return b.id == updatedBoard.id ? updatedBoard : b;
    }).toList();
    state = state.copyWith(boards: updated);
  }
}
