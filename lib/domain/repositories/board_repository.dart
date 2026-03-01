import '../entities/board.dart';
import '../entities/pin.dart';
import '../../core/network/api_response.dart';

abstract class BoardRepository {
  ApiResult<List<Board>> getBoards();
  ApiResult<Board> getBoard(String id);
  ApiResult<Board> createBoard(String name, {String? description, bool isPrivate = false});
  ApiResult<void> deleteBoard(String id);
  ApiResult<void> updateBoard(Board board);
  ApiResult<void> savePinToBoard(String boardId, Pin pin);
  ApiResult<void> removePinFromBoard(String boardId, int pinId);
  ApiResult<bool> isPinSaved(int pinId);
  ApiResult<List<int>> getAllSavedPinIds();
  ApiResult<List<Pin>> getSavedPins();
}
