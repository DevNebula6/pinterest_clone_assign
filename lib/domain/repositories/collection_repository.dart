import '../entities/collection.dart';
import '../entities/pin.dart';
import '../entities/search_result.dart';
import '../../core/network/api_response.dart';

abstract class CollectionRepository {
  ApiResult<SearchResult<Collection>> getFeaturedCollections({
    int page = 1,
    int perPage = 20,
  });

  ApiResult<SearchResult<Pin>> getCollectionMedia(
    String collectionId, {
    int page = 1,
    int perPage = 20,
  });
}
