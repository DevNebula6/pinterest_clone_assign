import 'package:equatable/equatable.dart';

// base class for all errors in the app - using sealed hierarchy instead of raw exceptions
abstract class Failure extends Equatable {
  const Failure({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

// something went wrong on the server side
class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    this.statusCode,
  });

  final int? statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}

// sharedprefs read/write failed
class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Cache error occurred.'});
}

// no internet
class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'No internet connection.'});
}

// auth token missing or expired
class AuthFailure extends Failure {
  const AuthFailure({super.message = 'Authentication failed. Please sign in again.'});
}

// catch-all for anything else
class UnknownFailure extends Failure {
  const UnknownFailure({super.message = 'An unexpected error occurred.'});
}
