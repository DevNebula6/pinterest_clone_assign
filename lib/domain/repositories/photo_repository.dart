import '../entities/pin.dart';
import '../entities/search_result.dart';
import '../../core/network/api_response.dart';

abstract class PhotoRepository {
  ApiResult<SearchResult<Pin>> getCuratedPhotos({int page = 1, int perPage = 20});
  ApiResult<Pin> getPhotoDetail(int id);
  ApiResult<SearchResult<Pin>> searchPhotos({
    required String query,
    int page = 1,
    int perPage = 20,
    String? orientation,
    String? size,
    String? color,
  });
}
