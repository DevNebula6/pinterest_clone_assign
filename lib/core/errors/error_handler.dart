import 'package:dio/dio.dart';

import '../constants/app_strings.dart';
import 'exceptions.dart';
import 'failures.dart';

// maps exceptions to failure objects and also has helper to get user-friendly messages
class ErrorHandler {
  ErrorHandler._();

  // turn a DioException into the right Failure type
  static Failure handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ServerFailure(message: AppStrings.errorTimeout);

      case DioExceptionType.connectionError:
        return const NetworkFailure();

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        return _mapStatusCode(statusCode, error.response?.statusMessage ?? '');

      case DioExceptionType.cancel:
        return const UnknownFailure(message: 'Request was cancelled.');

      case DioExceptionType.badCertificate:
        return const ServerFailure(message: 'SSL certificate error.');

      case DioExceptionType.unknown:
        if (error.error is NetworkException) {
          return const NetworkFailure();
        }
        return const UnknownFailure();
    }
  }

  // same but for any random exception
  static Failure handleException(dynamic exception) {
    if (exception is ServerException) {
      return ServerFailure(
        message: exception.message,
        statusCode: exception.statusCode,
      );
    }
    if (exception is CacheException) {
      return CacheFailure(message: exception.message);
    }
    if (exception is NetworkException) {
      return const NetworkFailure();
    }
    if (exception is AuthException) {
      return AuthFailure(message: exception.message);
    }
    if (exception is DioException) {
      return handleDioError(exception);
    }
    return const UnknownFailure();
  }

  // returns a message the user can actually read
  static String getErrorMessage(Failure failure) {
    if (failure is NetworkFailure) return AppStrings.errorNoInternet;
    if (failure is AuthFailure) return AppStrings.errorUnauthorized;
    if (failure is CacheFailure) return AppStrings.errorGeneric;
    if (failure is ServerFailure) {
      final code = failure.statusCode;
      if (code == 401) return AppStrings.errorUnauthorized;
      if (code == 404) return AppStrings.errorNotFound;
      if (code == 429) return AppStrings.errorRateLimit;
      if (code != null && code >= 500) return AppStrings.errorServer;
      return failure.message.isNotEmpty
          ? failure.message
          : AppStrings.errorGeneric;
    }
    return AppStrings.errorGeneric;
  }

  //  
  // Private helpers
  //  

  static Failure _mapStatusCode(int? statusCode, String message) {
    switch (statusCode) {
      case 401:
        return const AuthFailure();
      case 404:
        return const ServerFailure(
          message: AppStrings.errorNotFound,
          statusCode: 404,
        );
      case 429:
        return const ServerFailure(
          message: AppStrings.errorRateLimit,
          statusCode: 429,
        );
      default:
        if (statusCode != null && statusCode >= 500) {
          return ServerFailure(
            message: AppStrings.errorServer,
            statusCode: statusCode,
          );
        }
        return ServerFailure(
          message: message.isNotEmpty ? message : AppStrings.errorGeneric,
          statusCode: statusCode,
        );
    }
  }
}
