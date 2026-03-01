import '../repositories/user_repository.dart';
import '../../core/network/api_response.dart';

class ClearUser {
  ClearUser(this.repository);

  final UserRepository repository;

  ApiResult<void> call() {
    return repository.clearUser();
  }
}
