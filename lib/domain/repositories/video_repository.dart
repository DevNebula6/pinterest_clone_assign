import '../entities/video_pin.dart';
import '../entities/search_result.dart';
import '../../core/network/api_response.dart';

abstract class VideoRepository {
  ApiResult<SearchResult<VideoPin>> getPopularVideos({int page = 1, int perPage = 20});
  ApiResult<VideoPin> getVideoDetail(int id);
  ApiResult<SearchResult<VideoPin>> searchVideos({
    required String query,
    int page = 1,
    int perPage = 20,
  });
}
