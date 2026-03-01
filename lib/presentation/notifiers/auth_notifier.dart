import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/get_profile.dart';
import '../../domain/usecases/save_user.dart';
import '../../domain/usecases/clear_user.dart';
import 'auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier({
    required this.getProfile,
    required this.saveUser,
    required this.clearUser,
  }) : super(const AuthState());

  final GetProfile getProfile;
  final SaveUser saveUser;
  final ClearUser clearUser;

  Future<void> checkAuth() async {
    state = state.copyWith(isLoading: true);

    final result = await getProfile();

    if (!mounted) return;

    result.fold(
      (failure) {
        state = state.copyWith(
          status: AuthStatus.unauthenticated,
          isLoading: false,
          clearUser: true,
        );
      },
      (user) {
        if (user != null) {
          state = state.copyWith(
            status: AuthStatus.authenticated,
            currentUser: user,
            isLoading: false,
            clearError: true,
          );
        } else {
          state = state.copyWith(
            status: AuthStatus.unauthenticated,
            isLoading: false,
            clearUser: true,
          );
        }
      },
    );
  }

  Future<void> signIn(String email, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);
    // clerk handles the actual sign-in, this stub just clears the loading flag
    state = state.copyWith(isLoading: false);
  }

  Future<void> signUp(String name, String email, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);
    // clerk handles sign-up too, just clear the loader for now
    state = state.copyWith(isLoading: false);
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true);
    await clearUser();
    if (!mounted) return;
    state = state.copyWith(
      status: AuthStatus.unauthenticated,
      isLoading: false,
      clearUser: true,
      clearError: true,
    );
  }

  void setAuthenticatedUser(User user) {
    state = state.copyWith(
      status: AuthStatus.authenticated,
      currentUser: user,
      clearError: true,
    );
  }

  void setUnauthenticated() {
    state = state.copyWith(
      status: AuthStatus.unauthenticated,
      clearUser: true,
    );
  }

  void setError(Failure failure) {
    state = state.copyWith(
      isLoading: false,
      error: failure,
      status: AuthStatus.unauthenticated,
    );
  }
}
