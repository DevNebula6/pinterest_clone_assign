import '../entities/board.dart';
import '../repositories/board_repository.dart';
import '../../core/network/api_response.dart';

class CreateBoard {
  CreateBoard(this.repository);

  final BoardRepository repository;

  ApiResult<Board> call(
    String name, {
    String? description,
    bool isPrivate = false,
  }) {
    return repository.createBoard(
      name,
      description: description,
      isPrivate: isPrivate,
    );
  }
}
