import '../repositories/search_repository.dart';
import '../../core/network/api_response.dart';

class GetRecentSearches {
  GetRecentSearches(this.repository);

  final SearchRepository repository;

  ApiResult<List<String>> call() {
    return repository.getRecentSearches();
  }
}
