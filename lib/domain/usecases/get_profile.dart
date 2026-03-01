import '../entities/user.dart';
import '../repositories/user_repository.dart';
import '../../core/network/api_response.dart';

class GetProfile {
  GetProfile(this.repository);

  final UserRepository repository;

  ApiResult<User?> call() {
    return repository.getCurrentUser();
  }
}
