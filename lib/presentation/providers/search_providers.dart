import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/pin.dart';
import '../notifiers/search_notifier.dart';
import '../notifiers/search_state.dart';
import 'usecase_providers.dart';

final searchNotifierProvider =
    StateNotifierProvider<SearchNotifier, SearchState>((ref) {
  return SearchNotifier(
    searchPhotos: ref.watch(searchPhotosProvider),
    getRecentSearches: ref.watch(getRecentSearchesProvider),
    saveRecentSearch: ref.watch(saveRecentSearchProvider),
    clearRecentSearches: ref.watch(clearRecentSearchesProvider),
  );
});

// Convenience selectors
final searchResultsProvider = Provider<List<Pin>>((ref) {
  return ref.watch(searchNotifierProvider).results;
});

final searchStatusProvider = Provider<SearchStatus>((ref) {
  return ref.watch(searchNotifierProvider).status;
});

final searchQueryProvider = Provider<String>((ref) {
  return ref.watch(searchNotifierProvider).query;
});

final recentSearchesProvider = Provider<List<String>>((ref) {
  return ref.watch(searchNotifierProvider).recentSearches;
});

final searchCategoriesProvider = Provider<List<SearchCategory>>((ref) {
  return ref.watch(searchNotifierProvider).categories;
});

final activeSearchFilterProvider = Provider<SearchFilter>((ref) {
  return ref.watch(searchNotifierProvider).activeFilter;
});

final isSearchLoadingMoreProvider = Provider<bool>((ref) {
  return ref.watch(searchNotifierProvider).isLoadingMore;
});
