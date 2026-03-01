import '../entities/collection.dart';
import '../entities/search_result.dart';
import '../repositories/collection_repository.dart';
import '../../core/network/api_response.dart';

class GetCollections {
  GetCollections(this.repository);

  final CollectionRepository repository;

  ApiResult<SearchResult<Collection>> call({int page = 1, int perPage = 20}) {
    return repository.getFeaturedCollections(page: page, perPage: perPage);
  }
}
