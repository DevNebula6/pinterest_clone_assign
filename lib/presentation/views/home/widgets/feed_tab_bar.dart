import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../notifiers/home_feed_state.dart';
import '../../../providers/home_providers.dart';

class FeedTabBar extends ConsumerWidget {
  const FeedTabBar({super.key});

  static const List<(HomeFeedTab, String)> _tabs = [
    (HomeFeedTab.all, 'All'),
    (HomeFeedTab.forYou, 'For You'),
    (HomeFeedTab.today, 'Today'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTab = ref.watch(activeHomeFeedTabProvider);

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingLarge,
          vertical: 4,
        ),
        itemCount: _tabs.length,
        separatorBuilder: (_, __) =>
            const SizedBox(width: AppDimensions.paddingSmall),
        itemBuilder: (context, index) {
          final (tab, label) = _tabs[index];
          final isActive = activeTab == tab;

          return GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              ref
                  .read(homeFeedNotifierProvider.notifier)
                  .changeTab(tab);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingLarge,
                vertical: AppDimensions.paddingSmall,
              ),
              decoration: BoxDecoration(
                color: isActive ? AppColors.textPrimary : Colors.transparent,
                borderRadius:
                    BorderRadius.circular(AppDimensions.radiusRound),
                border: Border.all(
                  color:
                      isActive ? AppColors.textPrimary : AppColors.divider,
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
