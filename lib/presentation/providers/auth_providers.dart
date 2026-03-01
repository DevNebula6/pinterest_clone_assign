import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user.dart';
import '../notifiers/auth_notifier.dart';
import '../notifiers/auth_state.dart';
import 'usecase_providers.dart';

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    getProfile: ref.watch(getProfileProvider),
    saveUser: ref.watch(saveUserProvider),
    clearUser: ref.watch(clearUserProvider),
  );
});

// Convenience selectors
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authNotifierProvider).isAuthenticated;
});

final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authNotifierProvider).currentUser;
});

final authStatusProvider = Provider<AuthStatus>((ref) {
  return ref.watch(authNotifierProvider).status;
});
