import '../../core/network/api_response.dart';

abstract class SearchRepository {
  ApiResult<List<String>> getRecentSearches();
  ApiResult<void> saveRecentSearch(String query);
  ApiResult<void> clearRecentSearches();
}
