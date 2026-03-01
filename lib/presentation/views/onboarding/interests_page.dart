import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import 'onboarding_data.dart';

// the interests grid page - user picks what they're interested in
class InterestsPage extends StatelessWidget {
  const InterestsPage({
    super.key,
    required this.selected,
    required this.onToggle,
  });

  final Set<String> selected;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    final remaining = 3 - selected.length;
    final subtitle = selected.length < 3
        ? 'Pick ${remaining == 3 ? "3 or more" : "more"} to curate your experience'
        : 'Pick more to curate your experience';

    return Column(
      children: [
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingXLarge),
          child: Text(
            'What are you in the mood to do?',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingXLarge),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Text(
              subtitle,
              key: ValueKey(subtitle),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.75,
              crossAxisSpacing: 8,
              mainAxisSpacing: 12,
            ),
            itemCount: OnboardingData.interests.length,
            itemBuilder: (_, i) {
              final interest = OnboardingData.interests[i];
              final isSelected = selected.contains(interest.label);
              return _InterestTile(
                interest: interest,
                isSelected: isSelected,
                onTap: () => onToggle(interest.label),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _InterestTile extends StatelessWidget {
  const _InterestTile({
    required this.interest,
    required this.isSelected,
    required this.onTap,
  });

  final InterestCategory interest;
  final bool isSelected;
  final VoidCallback onTap;

  String get _imageUrl {
    final key = dotenv.env['PEXELS_API_KEY'] ?? '';
    if (key.isEmpty) return '';
    // Use a deterministic Pexels URL via search — we'll use a direct URL
    // based on the query. For simplicity we use picsum.photos with a seed.
    return 'https://picsum.photos/seed/${interest.query}/200/240';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                border: Border.all(
                  color: isSelected ? AppColors.pinterestRed : Colors.transparent,
                  width: isSelected ? 3 : 0,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                    isSelected ? AppDimensions.radiusMedium - 2 : AppDimensions.radiusMedium),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: _imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        color: AppColors.lightGray,
                        child: Center(
                          child: Text(
                            interest.emoji,
                            style: const TextStyle(fontSize: 32),
                          ),
                        ),
                      ),
                      errorWidget: (_, __, ___) => Container(
                        color: AppColors.lightGray,
                        child: Center(
                          child: Text(
                            interest.emoji,
                            style: const TextStyle(fontSize: 32),
                          ),
                        ),
                      ),
                    ),
                    // Selection overlay with animated checkmark
                    AnimatedOpacity(
                      opacity: isSelected ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 200),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.white.withValues(alpha: 0.85),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: AppColors.textPrimary,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            interest.label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                  height: 1.2,
                ),
          ),
        ],
      ),
    );
  }
}
