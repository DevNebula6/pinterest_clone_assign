import 'package:equatable/equatable.dart';

// Generic search result wrapper that holds a paginated list of items
class SearchResult<T> extends Equatable {
  const SearchResult({
    required this.items,
    required this.totalResults,
    required this.currentPage,
    required this.hasMore,
    this.nextPageUrl,
  });

  final List<T> items;
  final int totalResults;
  final int currentPage;
  final bool hasMore;
  final String? nextPageUrl;

  @override
  List<Object?> get props => [items, totalResults, currentPage, hasMore];
}
