import '../entities/search_result.dart';
import '../entities/video_pin.dart';
import '../repositories/video_repository.dart';
import '../../core/network/api_response.dart';

class SearchVideos {
  SearchVideos(this.repository);

  final VideoRepository repository;

  ApiResult<SearchResult<VideoPin>> call({
    required String query,
    int page = 1,
    int perPage = 20,
  }) {
    return repository.searchVideos(query: query, page: page, perPage: perPage);
  }
}
