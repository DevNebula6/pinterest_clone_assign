import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/get_boards.dart';
import '../../domain/usecases/get_curated_photos.dart';
import '../../domain/usecases/get_saved_pins.dart';
import 'profile_state.dart';
import 'auth_notifier.dart';

class ProfileNotifier extends StateNotifier<ProfileState> {
  ProfileNotifier({
    required this.getBoards,
    required this.getCuratedPhotos,
    required this.getSavedPins,
    required this.authNotifier,
  }) : super(const ProfileState());

  final GetBoards getBoards;
  final GetCuratedPhotos getCuratedPhotos;
  final GetSavedPins getSavedPins;
  final AuthNotifier authNotifier;

  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true, clearError: true);

    final user = authNotifier.state.currentUser;
    if (user == null) {
      state = state.copyWith(isLoading: false);
      return;
    }

    final boardsResult = await getBoards();
    final pinsResult = await getCuratedPhotos(page: 3, perPage: 20);
    final savedResult = await getSavedPins();

    if (!mounted) return;

    boardsResult.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure);
      },
      (boards) {
        final savedPins = savedResult.fold((_) => <dynamic>[], (pins) => pins);
        pinsResult.fold(
          (failure) {
            state = state.copyWith(
              user: user,
              boards: boards,
              savedPins: List.from(savedPins),
              isLoading: false,
              clearError: true,
            );
          },
          (searchResult) {
            state = state.copyWith(
              user: user,
              boards: boards,
              createdPins: searchResult.items,
              savedPins: List.from(savedPins),
              isLoading: false,
              clearError: true,
            );
          },
        );
      },
    );
  }

  void changeTab(ProfileTab tab) {
    state = state.copyWith(activeTab: tab);
  }

  Future<void> refreshProfile() async {
    await loadProfile();
  }
}
