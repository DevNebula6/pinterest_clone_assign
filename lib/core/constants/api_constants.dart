// api urls and endpoint paths for pexels
class ApiConstants {
  ApiConstants._();

  //  
  // Base URLs
  //  
  static const String pexelsBaseUrl = 'https://api.pexels.com';
  static const String photosPath = '/v1';
  static const String videosPath = '/videos';

  //  
  // Pagination defaults
  //  
  static const int defaultPerPage = 20;
  static const int maxPerPage = 80;
  static const int firstPage = 1;

  //  
  // Timeouts
  //  
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
  static const Duration sendTimeout = Duration(seconds: 15);

  //  
  // Rate limiting (Pexels: 200 requests / hour)
  //  
  static const int rateLimit = 200;
  static const Duration rateLimitWindow = Duration(hours: 1);

  //  
  // Cache keys
  //  
  static const String cacheKeyCurated = 'curated';
  static const String cacheKeyPopularVideos = 'popular_videos';
  static String cacheKeySearch(String query) => 'search_$query';
}
