import '../entities/search_result.dart';
import '../entities/video_pin.dart';
import '../repositories/video_repository.dart';
import '../../core/network/api_response.dart';

class GetPopularVideos {
  GetPopularVideos(this.repository);

  final VideoRepository repository;

  ApiResult<SearchResult<VideoPin>> call({int page = 1, int perPage = 20}) {
    return repository.getPopularVideos(page: page, perPage: perPage);
  }
}
