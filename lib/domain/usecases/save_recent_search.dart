import '../repositories/search_repository.dart';
import '../../core/network/api_response.dart';

class SaveRecentSearch {
  SaveRecentSearch(this.repository);

  final SearchRepository repository;

  ApiResult<void> call(String query) {
    return repository.saveRecentSearch(query);
  }
}
