import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/avatar_widget.dart';
import '../../../presentation/providers/auth_providers.dart';
import '../../../presentation/providers/core_providers.dart';
import '../../../presentation/providers/profile_providers.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topPad = MediaQuery.of(context).padding.top;
    final user = ref.watch(profileUserProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: Column(
        children: [
          SizedBox(height: topPad),
          // top bar
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingMedium,
              vertical: AppDimensions.paddingSmall,
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 20),
                  onPressed: () => context.pop(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                ),
                const Expanded(
                  child: Text(
                    'Your account',
                    style: AppTypography.h2,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 40), // balance the back button
              ],
            ),
          ),
          // content
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // user info card at the top
                _buildUserCard(context, ref, user),
                const SizedBox(height: 24),
                // settings items
                const _SectionHeader(title: 'Settings'),
                _SettingsTile(label: 'Account management', onTap: () {}),
                _SettingsTile(label: 'Profile visibility', onTap: () {}),
                _SettingsTile(label: 'Refine your recommendations', onTap: () {}),
                _SettingsTile(label: 'Claimed external accounts', onTap: () {}),
                _SettingsTile(label: 'Social permissions', onTap: () {}),
                _SettingsTile(label: 'Notifications', onTap: () {}),
                _SettingsTile(label: 'Privacy and data', onTap: () {}),
                _SettingsTile(label: 'Reports and violations centre', onTap: () {}),
                const SizedBox(height: 8),
                // account/login items
                const _SectionHeader(title: 'Login'),
                _SettingsTile(label: 'Add account', onTap: () {}),
                _SettingsTile(label: 'Security', onTap: () {}),
                const SizedBox(height: AppDimensions.paddingLarge),
                // logout button at the bottom
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingLarge,
                  ),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.pinterestRed),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () async {
                      final prefs = ref.read(sharedPreferencesProvider);
                      final clerkState = ClerkAuth.of(context, listen: false);
                      final authNotifier = ref.read(authNotifierProvider.notifier);
                      final nav = GoRouter.of(context);

                      await prefs.remove('has_completed_onboarding');
                      await clerkState.signOut();
                      await authNotifier.signOut();
                      nav.go('/login');
                    },
                    child: Text(
                      'Log out',
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.pinterestRed,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(BuildContext context, WidgetRef ref, user) {
    final name = user?.name ?? 'User';
    final username = user?.username;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingLarge),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.lightGray,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        ),
        child: Column(
          children: [
            Row(
              children: [
                AvatarWidget(
                  size: 56,
                  imageUrl: user?.avatarUrl,
                  name: name,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: AppTypography.h3,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (username != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          '@$username',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.divider),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: AppColors.white,
                    ),
                    onPressed: () => context.push('/profile/edit'),
                    child: Text(
                      'View profile',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.divider),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: AppColors.white,
                    ),
                    onPressed: () {
                      Share.share(
                        'Check out $name on Pinterest!',
                      );
                    },
                    child: Text(
                      'Share profile',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.paddingLarge,
        AppDimensions.paddingLarge,
        AppDimensions.paddingLarge,
        AppDimensions.paddingSmall,
      ),
      child: Text(
        title,
        style: AppTypography.h3,
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingLarge,
        vertical: 2,
      ),
      title: Text(
        label,
        style: AppTypography.bodyMedium.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: AppColors.textSecondary,
        size: 16,
      ),
      onTap: onTap,
    );
  }
}
