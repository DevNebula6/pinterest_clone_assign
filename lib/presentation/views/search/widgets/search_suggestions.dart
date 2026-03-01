import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../providers/search_providers.dart';

class SearchSuggestions extends ConsumerWidget {
  const SearchSuggestions({
    super.key,
    required this.onSuggestionTap,
  });

  final ValueChanged<String> onSuggestionTap;

  static const List<String> _trendingSearches = [
    'Minimalist interior design',
    'Astrophotography',
    'Botanical illustrations',
    'Street food photography',
    'Abstract watercolor art',
    'Sustainable fashion',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recentSearches = ref.watch(recentSearchesProvider);
    final query = ref.watch(searchQueryProvider);

    // Filter recent and trending by current query prefix
    final filteredRecent = recentSearches
        .where(
          (s) => s.toLowerCase().contains(query.toLowerCase()),
        )
        .take(5)
        .toList();

    final filteredTrending = query.isEmpty
        ? _trendingSearches
        : _trendingSearches
            .where(
              (s) => s.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();

    return ListView(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        if (filteredRecent.isNotEmpty) ...[
          _buildSectionHeader(
            context,
            ref,
            title: 'Recent',
            showClearAll: true,
          ),
          ...filteredRecent.map(
            (search) => _buildRecentItem(context, ref, search),
          ),
        ],
        if (filteredTrending.isNotEmpty) ...[
          _buildSectionLabel('Trending'),
          ...filteredTrending.map(
            (search) => _buildTrendingItem(search),
          ),
        ],
      ],
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    WidgetRef ref, {
    required String title,
    bool showClearAll = false,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.paddingLarge,
        AppDimensions.paddingMedium,
        AppDimensions.paddingMedium,
        4,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTypography.labelMedium),
          if (showClearAll)
            GestureDetector(
              onTap: () {
                ref
                    .read(searchNotifierProvider.notifier)
                    .clearAllRecentSearches();
              },
              child: Text(
                'Clear all',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.paddingLarge,
        AppDimensions.paddingMedium,
        AppDimensions.paddingMedium,
        4,
      ),
      child: Text(title, style: AppTypography.labelMedium),
    );
  }

  Widget _buildRecentItem(
    BuildContext context,
    WidgetRef ref,
    String search,
  ) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingLarge,
        vertical: 0,
      ),
      leading: const Icon(
        Icons.history_rounded,
        size: AppDimensions.iconSmall,
        color: AppColors.textSecondary,
      ),
      title: Text(search, style: AppTypography.bodyMedium),
      trailing: GestureDetector(
        onTap: () => ref
            .read(searchNotifierProvider.notifier)
            .removeRecentSearch(search),
        child: const Icon(
          Icons.close_rounded,
          size: AppDimensions.iconSmall,
          color: AppColors.textTertiary,
        ),
      ),
      onTap: () => onSuggestionTap(search),
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildTrendingItem(String search) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingLarge,
        vertical: 0,
      ),
      leading: const Icon(
        Icons.trending_up_rounded,
        size: AppDimensions.iconSmall,
        color: AppColors.textSecondary,
      ),
      title: Text(search, style: AppTypography.bodyMedium),
      onTap: () => onSuggestionTap(search),
      visualDensity: VisualDensity.compact,
    );
  }
}
