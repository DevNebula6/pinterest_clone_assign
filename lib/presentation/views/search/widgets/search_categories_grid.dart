import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/widgets/shimmer_widget.dart';
import '../../../notifiers/search_state.dart';
import '../../../providers/search_providers.dart';

class SearchCategoriesGrid extends ConsumerWidget {
  const SearchCategoriesGrid({
    super.key,
    required this.onCategoryTap,
  });

  final ValueChanged<String> onCategoryTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(searchCategoriesProvider);

    if (categories.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.gridPadding,
        vertical: AppDimensions.paddingSmall,
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 4 / 3,
          crossAxisSpacing: AppDimensions.gridCrossAxisSpacing,
          mainAxisSpacing: AppDimensions.gridMainAxisSpacing,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return _CategoryCard(
            category: categories[index],
            onTap: () => onCategoryTap(categories[index].name),
          );
        },
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.category,
    required this.onTap,
  });

  final SearchCategory category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: category.imageUrl,
              fit: BoxFit.cover,
              placeholder: (_, __) => const ShimmerWidget(
                width: double.infinity,
                height: double.infinity,
                borderRadius: AppDimensions.radiusLarge,
              ),
              errorWidget: (_, __, ___) => Container(
                color: AppColors.lightGray,
                child: const Icon(
                  Icons.image_outlined,
                  color: AppColors.textTertiary,
                  size: 32,
                ),
              ),
            ),
            // Dark gradient overlay
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Color(0xCC000000),
                  ],
                  stops: [0.4, 1.0],
                ),
              ),
            ),
            // Category label
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: Text(
                category.name,
                textAlign: TextAlign.center,
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.white,
                  shadows: [
                    const Shadow(
                      blurRadius: 4,
                      color: Colors.black26,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
