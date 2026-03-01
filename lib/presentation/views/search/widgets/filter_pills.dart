import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../notifiers/search_state.dart';
import '../../../providers/search_providers.dart';

class FilterPills extends ConsumerWidget {
  const FilterPills({super.key});

  static const List<(String, String?)> _filters = [
    ('All', null),
    ('Landscape', 'landscape'),
    ('Portrait', 'portrait'),
    ('Square', 'square'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeFilter = ref.watch(activeSearchFilterProvider);

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingLarge,
          vertical: 2,
        ),
        itemCount: _filters.length,
        separatorBuilder: (_, __) =>
            const SizedBox(width: AppDimensions.paddingSmall),
        itemBuilder: (context, index) {
          final (label, orientation) = _filters[index];
          final isActive = activeFilter.orientation == orientation;

          return GestureDetector(
            onTap: () {
              final newFilter = SearchFilter(
                orientation: orientation,
              );
              ref
                  .read(searchNotifierProvider.notifier)
                  .applyFilter(newFilter);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingLarge,
                vertical: AppDimensions.paddingSmall,
              ),
              decoration: BoxDecoration(
                color:
                    isActive ? AppColors.textPrimary : Colors.transparent,
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusRound),
                border: Border.all(
                  color: isActive
                      ? AppColors.textPrimary
                      : AppColors.divider,
                ),
              ),
              child: Text(
                label,
                style: AppTypography.labelSmall.copyWith(
                  color: isActive
                      ? AppColors.white
                      : AppColors.textPrimary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
