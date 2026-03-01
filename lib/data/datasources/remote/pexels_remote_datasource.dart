import '../../models/collection_model.dart';
import '../../models/pagination_model.dart';
import '../../models/photo_model.dart';
import '../../models/video_model.dart';

// Abstract contract for all Pexels API calls
abstract class PexelsRemoteDataSource {
  Future<PaginationModel<PhotoModel>> getCuratedPhotos({
    int page = 1,
    int perPage = 20,
  });

  Future<PhotoModel> getPhoto(int id);

  Future<PaginationModel<PhotoModel>> searchPhotos({
    required String query,
    int page = 1,
    int perPage = 20,
    String? orientation,
    String? size,
    String? color,
  });

  Future<PaginationModel<VideoModel>> getPopularVideos({
    int page = 1,
    int perPage = 20,
  });

  Future<VideoModel> getVideo(int id);

  Future<PaginationModel<VideoModel>> searchVideos({
    required String query,
    int page = 1,
    int perPage = 20,
  });

  Future<PaginationModel<CollectionModel>> getFeaturedCollections({
    int page = 1,
    int perPage = 20,
  });

  // returns photos from a specific collection
  Future<PaginationModel<PhotoModel>> getCollectionMedia(
    String collectionId, {
    int page = 1,
    int perPage = 20,
  });
}
