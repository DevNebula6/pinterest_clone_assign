// Generic wrapper for any paginated Pexels API response.
// The itemsKey tells us which JSON field contains the list (e.g. 'photos', 'videos').
class PaginationModel<T> {
  PaginationModel({
    required this.totalResults,
    required this.page,
    required this.perPage,
    required this.items,
    this.nextPage,
  });

  final int totalResults;
  final int page;
  final int perPage;
  final List<T> items;
  final String? nextPage;

  bool get hasMore => nextPage != null && nextPage!.isNotEmpty;

  static PaginationModel<T> fromJson<T>(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonFactory,
    String itemsKey,
  ) {
    final rawList = json[itemsKey] as List<dynamic>? ?? [];
    final items = rawList
        .map((e) => fromJsonFactory(e as Map<String, dynamic>))
        .toList();

    return PaginationModel<T>(
      totalResults: json['total_results'] as int? ?? 0,
      page: json['page'] as int? ?? 1,
      perPage: json['per_page'] as int? ?? 20,
      items: items,
      nextPage: json['next_page'] as String?,
    );
  }
}
