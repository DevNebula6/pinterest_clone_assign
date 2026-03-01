import '../repositories/board_repository.dart';
import '../../core/network/api_response.dart';

class DeleteBoard {
  DeleteBoard(this.repository);

  final BoardRepository repository;

  ApiResult<void> call(String boardId) {
    return repository.deleteBoard(boardId);
  }
}
