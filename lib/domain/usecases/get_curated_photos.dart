import '../entities/pin.dart';
import '../entities/search_result.dart';
import '../repositories/photo_repository.dart';
import '../../core/network/api_response.dart';

class GetCuratedPhotos {
  GetCuratedPhotos(this.repository);

  final PhotoRepository repository;

  ApiResult<SearchResult<Pin>> call({int page = 1, int perPage = 20}) {
    return repository.getCuratedPhotos(page: page, perPage: perPage);
  }
}
