import '../entities/pin.dart';
import '../repositories/board_repository.dart';
import '../../core/network/api_response.dart';

class GetSavedPins {
  GetSavedPins(this.repository);

  final BoardRepository repository;

  ApiResult<List<Pin>> call() {
    return repository.getSavedPins();
  }
}
