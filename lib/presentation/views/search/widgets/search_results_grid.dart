import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../domain/entities/pin.dart';
import '../../../notifiers/search_state.dart';
import '../../../providers/home_providers.dart';
import '../../../providers/search_providers.dart';
import '../../home/widgets/pin_card.dart';

class SearchResultsGrid extends ConsumerStatefulWidget {
  const SearchResultsGrid({
    super.key,
    required this.onRetry,
  });

  final VoidCallback onRetry;

  @override
  ConsumerState<SearchResultsGrid> createState() =>
      _SearchResultsGridState();
}

class _SearchResultsGridState extends ConsumerState<SearchResultsGrid> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final max = _scrollController.position.maxScrollExtent;
    final pixels = _scrollController.position.pixels;
    if (pixels >= max - 500) {
      ref.read(searchNotifierProvider.notifier).loadMoreResults();
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchNotifierProvider);
    final savedPinIds = ref.watch(
      homeFeedNotifierProvider.select((s) => s.savedPinIds),
    );

    return switch (searchState.status) {
      SearchStatus.loading => const Padding(
          padding: EdgeInsets.only(top: 60),
          child: LoadingWidget(),
        ),
      SearchStatus.error => AppErrorWidget(
          message: 'Search failed',
          subtitle: searchState.error?.message,
          onRetry: widget.onRetry,
        ),
      SearchStatus.empty => const _EmptyResults(),
      SearchStatus.results => _buildGrid(
          context,
          searchState.results,
          searchState.isLoadingMore,
          searchState.hasMoreResults,
          savedPinIds,
          searchState.totalResults,
        ),
      _ => const SizedBox.shrink(),
    };
  }

  Widget _buildGrid(
    BuildContext context,
    List<Pin> pins,
    bool isLoadingMore,
    bool hasMore,
    List<int> savedPinIds,
    int totalResults,
  ) {
    return CustomScrollView(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        if (totalResults > 0)
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingLarge,
              vertical: AppDimensions.paddingSmall,
            ),
            sliver: SliverToBoxAdapter(
              child: Text(
                '$totalResults results',
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
        SliverPadding(
          padding: const EdgeInsets.all(AppDimensions.gridPadding),
          sliver: SliverMasonryGrid.count(
            crossAxisCount: AppDimensions.gridColumnCount,
            mainAxisSpacing: AppDimensions.gridMainAxisSpacing,
            crossAxisSpacing: AppDimensions.gridCrossAxisSpacing,
            childCount: pins.length,
            itemBuilder: (context, index) {
              final pin = pins[index];
              return RepaintBoundary(
                child: PinCard(
                  pin: pin,
                  isSaved: savedPinIds.contains(pin.id),
                  heroTagSuffix: '',
                ),
              );
            },
          ),
        ),
        if (isLoadingMore)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: LoadingWidget(),
            ),
          ),
        if (!hasMore && pins.isNotEmpty)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  'No more results',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
        const SliverToBoxAdapter(child: SizedBox(height: 80)),
      ],
    );
  }
}

class _EmptyResults extends StatelessWidget {
  const _EmptyResults();

  @override
  Widget build(BuildContext context) {
    return const AppErrorWidget(
      message: 'No results found',
      subtitle: 'Try a different search term or adjust filters.',
      icon: Icons.search_off_rounded,
    );
  }
}
