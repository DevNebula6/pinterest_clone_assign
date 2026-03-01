import '../repositories/search_repository.dart';
import '../../core/network/api_response.dart';

class ClearRecentSearches {
  ClearRecentSearches(this.repository);

  final SearchRepository repository;

  ApiResult<void> call() {
    return repository.clearRecentSearches();
  }
}
