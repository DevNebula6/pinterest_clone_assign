import 'package:equatable/equatable.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/board.dart';

class BoardState extends Equatable {
  const BoardState({
    this.boards = const [],
    this.isLoading = false,
    this.error,
  });

  final List<Board> boards;
  final bool isLoading;
  final Failure? error;

  BoardState copyWith({
    List<Board>? boards,
    bool? isLoading,
    Failure? error,
    bool clearError = false,
  }) {
    return BoardState(
      boards: boards ?? this.boards,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [boards, isLoading, error];
}
