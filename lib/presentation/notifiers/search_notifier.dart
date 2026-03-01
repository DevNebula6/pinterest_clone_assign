import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/helpers/debouncer.dart';
import '../../domain/usecases/search_photos.dart';
import '../../domain/usecases/get_recent_searches.dart';
import '../../domain/usecases/save_recent_search.dart';
import '../../domain/usecases/clear_recent_searches.dart';
import 'search_state.dart';

const List<SearchCategory> _defaultCategories = [
  SearchCategory(
    name: 'Nature',
    imageUrl: 'https://images.pexels.com/photos/417173/pexels-photo-417173.jpeg?auto=compress&cs=tinysrgb&w=400',
  ),
  SearchCategory(
    name: 'Architecture',
    imageUrl: 'https://images.pexels.com/photos/1098460/pexels-photo-1098460.jpeg?auto=compress&cs=tinysrgb&w=400',
  ),
  SearchCategory(
    name: 'Food',
    imageUrl: 'https://images.pexels.com/photos/1640777/pexels-photo-1640777.jpeg?auto=compress&cs=tinysrgb&w=400',
  ),
  SearchCategory(
    name: 'Travel',
    imageUrl: 'https://images.pexels.com/photos/1591373/pexels-photo-1591373.jpeg?auto=compress&cs=tinysrgb&w=400',
  ),
  SearchCategory(
    name: 'Fashion',
    imageUrl: 'https://images.pexels.com/photos/1536619/pexels-photo-1536619.jpeg?auto=compress&cs=tinysrgb&w=400',
  ),
  SearchCategory(
    name: 'Technology',
    imageUrl: 'https://images.pexels.com/photos/356056/pexels-photo-356056.jpeg?auto=compress&cs=tinysrgb&w=400',
  ),
  SearchCategory(
    name: 'Art',
    imageUrl: 'https://images.pexels.com/photos/1266808/pexels-photo-1266808.jpeg?auto=compress&cs=tinysrgb&w=400',
  ),
  SearchCategory(
    name: 'Animals',
    imageUrl: 'https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg?auto=compress&cs=tinysrgb&w=400',
  ),
];

class SearchNotifier extends StateNotifier<SearchState> {
  SearchNotifier({
    required this.searchPhotos,
    required this.getRecentSearches,
    required this.saveRecentSearch,
    required this.clearRecentSearches,
  }) : _debouncer = Debouncer(delay: const Duration(milliseconds: 300)),
       super(const SearchState());

  final SearchPhotos searchPhotos;
  final GetRecentSearches getRecentSearches;
  final SaveRecentSearch saveRecentSearch;
  final ClearRecentSearches clearRecentSearches;
  final Debouncer _debouncer;

  static const int _perPage = 20;

  Future<void> loadInitialState() async {
    final result = await getRecentSearches();
    result.fold(
      (failure) => null,
      (searches) {
        state = state.copyWith(
          recentSearches: searches,
          categories: _defaultCategories,
          status: SearchStatus.initial,
        );
      },
    );
  }

  void onQueryChanged(String query) {
    state = state.copyWith(query: query);
    if (query.trim().isEmpty) {
      state = state.copyWith(status: SearchStatus.initial, results: []);
      _debouncer.cancel();
      return;
    }
    _debouncer.run(() {
      if (state.query.isNotEmpty) {
        _fetchSuggestions(query);
      }
    });
  }

  Future<void> _fetchSuggestions(String query) async {
    if (!mounted) return;
    state = state.copyWith(status: SearchStatus.loading);
    final filter = state.activeFilter;
    final result = await searchPhotos(
      query: query,
      page: 1,
      perPage: _perPage,
      orientation: filter.orientation,
      size: filter.size,
      color: filter.color,
    );
    if (!mounted) return;
    result.fold(
      (failure) {
        state = state.copyWith(status: SearchStatus.error, error: failure);
      },
      (searchResult) {
        state = state.copyWith(
          results: searchResult.items,
          status: searchResult.items.isEmpty ? SearchStatus.empty : SearchStatus.results,
          currentPage: 1,
          hasMoreResults: searchResult.hasMore,
          totalResults: searchResult.totalResults,
          clearError: true,
        );
      },
    );
  }

  Future<void> search(String query) async {
    if (query.trim().isEmpty) return;

    state = state.copyWith(query: query, status: SearchStatus.loading, results: [], currentPage: 1);

    await saveRecentSearch(query);

    final filter = state.activeFilter;
    final result = await searchPhotos(
      query: query,
      page: 1,
      perPage: _perPage,
      orientation: filter.orientation,
      size: filter.size,
      color: filter.color,
    );

    if (!mounted) return;

    result.fold(
      (failure) {
        state = state.copyWith(status: SearchStatus.error, error: failure);
      },
      (searchResult) {
        final recentResult = List<String>.from(state.recentSearches);
        if (!recentResult.contains(query)) {
          recentResult.insert(0, query);
        }
        state = state.copyWith(
          results: searchResult.items,
          status: searchResult.items.isEmpty ? SearchStatus.empty : SearchStatus.results,
          currentPage: 1,
          hasMoreResults: searchResult.hasMore,
          totalResults: searchResult.totalResults,
          recentSearches: recentResult,
          clearError: true,
        );
      },
    );
  }

  Future<void> loadMoreResults() async {
    if (state.isLoadingMore || !state.hasMoreResults || state.query.isEmpty) return;

    state = state.copyWith(isLoadingMore: true);
    final nextPage = state.currentPage + 1;
    final filter = state.activeFilter;

    final result = await searchPhotos(
      query: state.query,
      page: nextPage,
      perPage: _perPage,
      orientation: filter.orientation,
      size: filter.size,
      color: filter.color,
    );

    if (!mounted) return;

    result.fold(
      (failure) {
        state = state.copyWith(isLoadingMore: false, error: failure);
      },
      (searchResult) {
        state = state.copyWith(
          results: [...state.results, ...searchResult.items],
          isLoadingMore: false,
          currentPage: nextPage,
          hasMoreResults: searchResult.hasMore,
        );
      },
    );
  }

  void clearSearch() {
    _debouncer.cancel();
    state = state.copyWith(
      query: '',
      status: SearchStatus.initial,
      results: [],
      currentPage: 1,
      hasMoreResults: false,
      clearError: true,
    );
  }

  void removeRecentSearch(String query) {
    final updated = List<String>.from(state.recentSearches)..remove(query);
    state = state.copyWith(recentSearches: updated);
  }

  Future<void> clearAllRecentSearches() async {
    await clearRecentSearches();
    state = state.copyWith(recentSearches: []);
  }

  Future<void> applyFilter(SearchFilter filter) async {
    state = state.copyWith(activeFilter: filter);
    if (state.query.isNotEmpty) {
      await search(state.query);
    }
  }

  @override
  void dispose() {
    _debouncer.cancel();
    super.dispose();
  }
}
