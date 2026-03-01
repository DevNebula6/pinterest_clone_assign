import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/get_curated_photos.dart';
import '../../domain/usecases/get_saved_pin_ids.dart';
import '../../domain/entities/pin.dart';
import 'home_feed_state.dart';

class HomeFeedNotifier extends StateNotifier<HomeFeedState> {
  HomeFeedNotifier({
    required this.getCuratedPhotos,
    required this.getSavedPinIds,
  }) : super(const HomeFeedState());

  final GetCuratedPhotos getCuratedPhotos;
  final GetSavedPinIds getSavedPinIds;

  static const int _perPage = 20;

  Future<void> loadInitialPins() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, clearError: true);

    final result = await getCuratedPhotos(page: 1, perPage: _perPage);

    result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure);
      },
      (searchResult) {
        List<Pin> pins = searchResult.items;
        if (state.activeTab == HomeFeedTab.forYou) {
          pins = List.from(pins)..shuffle();
        }
        state = state.copyWith(
          pins: pins,
          isLoading: false,
          currentPage: 1,
          hasReachedEnd: !searchResult.hasMore,
          clearError: true,
        );
        refreshSavedPinIds();
      },
    );
  }

  Future<void> loadMorePins() async {
    if (state.isLoadingMore || state.hasReachedEnd || state.isLoading) return;

    state = state.copyWith(isLoadingMore: true);

    final nextPage = state.currentPage + 1;
    final result = await getCuratedPhotos(page: nextPage, perPage: _perPage);

    result.fold(
      (failure) {
        state = state.copyWith(isLoadingMore: false, error: failure);
      },
      (searchResult) {
        final updatedPins = [...state.pins, ...searchResult.items];
        state = state.copyWith(
          pins: updatedPins,
          isLoadingMore: false,
          currentPage: nextPage,
          hasReachedEnd: !searchResult.hasMore,
        );
      },
    );
  }

  Future<void> refreshPins() async {
    state = state.copyWith(
      currentPage: 1,
      hasReachedEnd: false,
      pins: [],
      clearError: true,
    );
    await loadInitialPins();
  }

  void changeTab(HomeFeedTab tab) {
    if (state.activeTab == tab) return;
    state = state.copyWith(
      activeTab: tab,
      pins: [],
      currentPage: 1,
      hasReachedEnd: false,
      clearError: true,
    );
    loadInitialPins();
  }

  Future<void> refreshSavedPinIds() async {
    final result = await getSavedPinIds();
    result.fold(
      (failure) => null,
      (ids) => state = state.copyWith(savedPinIds: ids),
    );
  }
}
