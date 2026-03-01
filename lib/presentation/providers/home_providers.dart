import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/pin.dart';
import '../notifiers/home_feed_notifier.dart';
import '../notifiers/home_feed_state.dart';
import 'usecase_providers.dart';

final homeFeedNotifierProvider =
    StateNotifierProvider<HomeFeedNotifier, HomeFeedState>((ref) {
  return HomeFeedNotifier(
    getCuratedPhotos: ref.watch(getCuratedPhotosProvider),
    getSavedPinIds: ref.watch(getSavedPinIdsProvider),
  );
});

// Convenience selectors
final homePinsProvider = Provider<List<Pin>>((ref) {
  return ref.watch(homeFeedNotifierProvider).pins;
});

final isHomeFeedLoadingProvider = Provider<bool>((ref) {
  return ref.watch(homeFeedNotifierProvider).isLoading;
});

final isHomeFeedLoadingMoreProvider = Provider<bool>((ref) {
  return ref.watch(homeFeedNotifierProvider).isLoadingMore;
});

final hasHomeFeedReachedEndProvider = Provider<bool>((ref) {
  return ref.watch(homeFeedNotifierProvider).hasReachedEnd;
});

final activeHomeFeedTabProvider = Provider<HomeFeedTab>((ref) {
  return ref.watch(homeFeedNotifierProvider).activeTab;
});
