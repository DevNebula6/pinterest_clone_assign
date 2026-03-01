// server returned a non-2xx or the http request failed altogether
class ServerException implements Exception {
  const ServerException({
    required this.message,
    this.statusCode,
  });

  final String message;
  final int? statusCode;

  @override
  String toString() => 'ServerException($statusCode): $message';
}

// sharedprefs is being annoying
class CacheException implements Exception {
  const CacheException({this.message = 'Cache operation failed.'});

  final String message;

  @override
  String toString() => 'CacheException: $message';
}

// no wifi/data
class NetworkException implements Exception {
  const NetworkException({this.message = 'No internet connection.'});

  final String message;

  @override
  String toString() => 'NetworkException: $message';
}

// auth token is gone or invalid
class AuthException implements Exception {
  const AuthException({this.message = 'Authentication error.'});

  final String message;

  @override
  String toString() => 'AuthException: $message';
}
