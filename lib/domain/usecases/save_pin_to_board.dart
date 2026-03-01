import '../entities/pin.dart';
import '../repositories/board_repository.dart';
import '../../core/network/api_response.dart';

class SavePinToBoard {
  SavePinToBoard(this.repository);

  final BoardRepository repository;

  ApiResult<void> call(String boardId, Pin pin) {
    return repository.savePinToBoard(boardId, pin);
  }
}
