import '../entities/board.dart';
import '../repositories/board_repository.dart';
import '../../core/network/api_response.dart';

class GetBoards {
  GetBoards(this.repository);

  final BoardRepository repository;

  ApiResult<List<Board>> call() {
    return repository.getBoards();
  }
}
