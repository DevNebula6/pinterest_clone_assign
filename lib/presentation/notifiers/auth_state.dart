import 'package:equatable/equatable.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/user.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.unknown,
    this.currentUser,
    this.isLoading = false,
    this.error,
  });

  final AuthStatus status;
  final User? currentUser;
  final bool isLoading;
  final Failure? error;

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isUnauthenticated => status == AuthStatus.unauthenticated;
  bool get isUnknown => status == AuthStatus.unknown;

  AuthState copyWith({
    AuthStatus? status,
    User? currentUser,
    bool? isLoading,
    Failure? error,
    bool clearError = false,
    bool clearUser = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      currentUser: clearUser ? null : currentUser ?? this.currentUser,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, currentUser, isLoading, error];
}
