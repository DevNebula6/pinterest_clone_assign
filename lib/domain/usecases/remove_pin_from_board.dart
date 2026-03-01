import '../repositories/board_repository.dart';
import '../../core/network/api_response.dart';

class RemovePinFromBoard {
  RemovePinFromBoard(this.repository);

  final BoardRepository repository;

  ApiResult<void> call(String boardId, int pinId) {
    return repository.removePinFromBoard(boardId, pinId);
  }
}
