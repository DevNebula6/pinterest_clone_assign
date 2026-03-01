import '../entities/pin.dart';
import '../entities/search_result.dart';
import '../repositories/collection_repository.dart';
import '../../core/network/api_response.dart';

class GetCollectionMedia {
  GetCollectionMedia(this.repository);

  final CollectionRepository repository;

  ApiResult<SearchResult<Pin>> call(
    String collectionId, {
    int page = 1,
    int perPage = 20,
  }) {
    return repository.getCollectionMedia(
      collectionId,
      page: page,
      perPage: perPage,
    );
  }
}
