import '../repositories/board_repository.dart';
import '../../core/network/api_response.dart';

class GetSavedPinIds {
  GetSavedPinIds(this.repository);

  final BoardRepository repository;

  ApiResult<List<int>> call() {
    return repository.getAllSavedPinIds();
  }
}
