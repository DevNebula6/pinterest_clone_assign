// All Pexels API endpoint paths
class Endpoints {
  Endpoints._();

  // photos
  static const String curatedPhotos = '/v1/curated';
  static const String searchPhotos = '/v1/search';
  static String photoDetail(int id) => '/v1/photos/$id';

  // videos
  static const String popularVideos = '/videos/popular';
  static const String searchVideos = '/videos/search';
  static String videoDetail(int id) => '/videos/videos/$id';

  // collections
  static const String featuredCollections = '/v1/collections/featured';
  static String collectionMedia(String id) => '/v1/collections/$id';
}
