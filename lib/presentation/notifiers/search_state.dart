import 'package:equatable/equatable.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/pin.dart';

enum SearchStatus { initial, loading, results, empty, error }

class SearchFilter extends Equatable {
  const SearchFilter({
    this.orientation,
    this.size,
    this.color,
  });

  final String? orientation; // landscape, portrait, square
  final String? size;        // large, medium, small
  final String? color;       // hex color or color name

  bool get isActive => orientation != null || size != null || color != null;

  SearchFilter copyWith({
    String? orientation,
    String? size,
    String? color,
    bool clearOrientation = false,
    bool clearSize = false,
    bool clearColor = false,
  }) {
    return SearchFilter(
      orientation: clearOrientation ? null : orientation ?? this.orientation,
      size: clearSize ? null : size ?? this.size,
      color: clearColor ? null : color ?? this.color,
    );
  }

  @override
  List<Object?> get props => [orientation, size, color];
}

class SearchCategory extends Equatable {
  const SearchCategory({
    required this.name,
    required this.imageUrl,
  });

  final String name;
  final String imageUrl;

  @override
  List<Object?> get props => [name];
}

class SearchState extends Equatable {
  const SearchState({
    this.query = '',
    this.status = SearchStatus.initial,
    this.results = const [],
    this.recentSearches = const [],
    this.categories = const [],
    this.activeFilter = const SearchFilter(),
    this.error,
    this.currentPage = 1,
    this.hasMoreResults = false,
    this.isLoadingMore = false,
    this.totalResults = 0,
  });

  final String query;
  final SearchStatus status;
  final List<Pin> results;
  final List<String> recentSearches;
  final List<SearchCategory> categories;
  final SearchFilter activeFilter;
  final Failure? error;
  final int currentPage;
  final bool hasMoreResults;
  final bool isLoadingMore;
  final int totalResults;

  SearchState copyWith({
    String? query,
    SearchStatus? status,
    List<Pin>? results,
    List<String>? recentSearches,
    List<SearchCategory>? categories,
    SearchFilter? activeFilter,
    Failure? error,
    bool clearError = false,
    int? currentPage,
    bool? hasMoreResults,
    bool? isLoadingMore,
    int? totalResults,
  }) {
    return SearchState(
      query: query ?? this.query,
      status: status ?? this.status,
      results: results ?? this.results,
      recentSearches: recentSearches ?? this.recentSearches,
      categories: categories ?? this.categories,
      activeFilter: activeFilter ?? this.activeFilter,
      error: clearError ? null : error ?? this.error,
      currentPage: currentPage ?? this.currentPage,
      hasMoreResults: hasMoreResults ?? this.hasMoreResults,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      totalResults: totalResults ?? this.totalResults,
    );
  }

  @override
  List<Object?> get props => [
        query,
        status,
        results,
        recentSearches,
        categories,
        activeFilter,
        error,
        currentPage,
        hasMoreResults,
        isLoadingMore,
        totalResults,
      ];
}
