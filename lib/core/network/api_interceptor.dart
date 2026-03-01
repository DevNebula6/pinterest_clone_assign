import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../errors/error_handler.dart';
import '../errors/exceptions.dart';

// Adds the Authorization header to every request and handles common errors
class ApiInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    options.headers['Authorization'] = dotenv.env['PEXELS_API_KEY'] ?? '';
    print('[API] ${options.method} ${options.uri}');
    handler.next(options);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    print('[API] ${response.statusCode} ${response.requestOptions.uri}');
    handler.next(response);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    print('[API ERROR] ${err.response?.statusCode} ${err.requestOptions.uri}');

    if (err.response?.statusCode == 429) {
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          response: err.response,
          type: DioExceptionType.badResponse,
          error: const ServerException(
            message: 'Rate limit exceeded.',
            statusCode: 429,
          ),
        ),
      );
      return;
    }

    if (err.response?.statusCode == 401) {
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          response: err.response,
          type: DioExceptionType.badResponse,
          error: const AuthException(),
        ),
      );
      return;
    }

    final failure = ErrorHandler.handleDioError(err);
    print('[API FAILURE] ${failure.message}');

    handler.next(err);
  }
}
