import '../entities/user.dart';
import '../../core/network/api_response.dart';

abstract class UserRepository {
  ApiResult<User?> getCurrentUser();
  ApiResult<void> saveUser(User user);
  ApiResult<void> clearUser();
}
