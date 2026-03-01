import '../entities/user.dart';
import '../repositories/user_repository.dart';
import '../../core/network/api_response.dart';

class SaveUser {
  SaveUser(this.repository);

  final UserRepository repository;

  ApiResult<void> call(User user) {
    return repository.saveUser(user);
  }
}
