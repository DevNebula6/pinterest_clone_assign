import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import 'onboarding_data.dart';

// gender selection page
class GenderPage extends StatelessWidget {
  const GenderPage({
    super.key,
    required this.selectedGender,
    required this.onGenderSelected,
  });

  final String selectedGender;
  final ValueChanged<String> onGenderSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: AppDimensions.paddingXLarge),
      child: Column(
        children: [
          const SizedBox(height: 48),
          Text(
            'What\'s your gender?',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'This helps us find you more relevant content.\n'
            'We won\'t show it on your profile.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
          ),
          const SizedBox(height: 32),
          ...OnboardingData.genders.map((gender) {
            final isSelected = gender == selectedGender;
            return _GenderOption(
              label: gender,
              isSelected: isSelected,
              onTap: () => onGenderSelected(gender),
            );
          }),
        ],
      ),
    );
  }
}

class _GenderOption extends StatelessWidget {
  const _GenderOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? AppColors.pinterestRed : AppColors.divider,
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected
                          ? AppColors.pinterestRed
                          : AppColors.textPrimary,
                    ),
              ),
            ),
            AnimatedOpacity(
              opacity: isSelected ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: const Icon(Icons.check,
                  color: AppColors.pinterestRed, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}
