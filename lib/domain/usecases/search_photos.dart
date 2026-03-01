import '../entities/pin.dart';
import '../entities/search_result.dart';
import '../repositories/photo_repository.dart';
import '../../core/network/api_response.dart';

class SearchPhotos {
  SearchPhotos(this.repository);

  final PhotoRepository repository;

  ApiResult<SearchResult<Pin>> call({
    required String query,
    int page = 1,
    int perPage = 20,
    String? orientation,
    String? size,
    String? color,
  }) {
    return repository.searchPhotos(
      query: query,
      page: page,
      perPage: perPage,
      orientation: orientation,
      size: size,
      color: color,
    );
  }
}
