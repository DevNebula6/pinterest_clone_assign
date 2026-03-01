import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/board.dart';
import '../../domain/entities/pin.dart';
import '../../domain/entities/user.dart';
import '../notifiers/profile_notifier.dart';
import '../notifiers/profile_state.dart';
import 'auth_providers.dart';
import 'usecase_providers.dart';

final profileNotifierProvider =
    StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  return ProfileNotifier(
    getBoards: ref.watch(getBoardsProvider),
    getCuratedPhotos: ref.watch(getCuratedPhotosProvider),
    getSavedPins: ref.watch(getSavedPinsProvider),
    authNotifier: ref.watch(authNotifierProvider.notifier),
  );
});

// Convenience selectors
final profileUserProvider = Provider<User?>((ref) {
  return ref.watch(profileNotifierProvider).user;
});

final profileBoardsProvider = Provider<List<Board>>((ref) {
  return ref.watch(profileNotifierProvider).boards;
});

final profileCreatedPinsProvider = Provider<List<Pin>>((ref) {
  return ref.watch(profileNotifierProvider).createdPins;
});

final profileSavedPinsProvider = Provider<List<Pin>>((ref) {
  return ref.watch(profileNotifierProvider).savedPins;
});

final isProfileLoadingProvider = Provider<bool>((ref) {
  return ref.watch(profileNotifierProvider).isLoading;
});

final activeProfileTabProvider = Provider<ProfileTab>((ref) {
  return ref.watch(profileNotifierProvider).activeTab;
});
