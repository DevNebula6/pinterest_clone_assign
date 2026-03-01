import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/widgets/avatar_widget.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../presentation/notifiers/profile_state.dart';
import '../../../presentation/providers/profile_providers.dart';
import 'widgets/created_pins_grid.dart';
import 'widgets/saved_boards_grid.dart';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileNotifierProvider.notifier).loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileNotifierProvider);
    final topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: _buildBody(profileState, topPad),
    );
  }

  Widget _buildBody(ProfileState profileState, double topPad) {
    if (profileState.isLoading && profileState.user == null) {
      return const Center(child: LoadingWidget());
    }

    if (profileState.error != null && profileState.user == null) {
      return AppErrorWidget(
        message: 'Could not load profile',
        onRetry: () => ref.read(profileNotifierProvider.notifier).loadProfile(),
      );
    }

    final user = profileState.user;
    if (user == null) {
      return const Center(child: LoadingWidget());
    }

    return RefreshIndicator(
      color: AppColors.pinterestRed,
      onRefresh: () => ref.read(profileNotifierProvider.notifier).refreshProfile(),
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                SizedBox(height: topPad),
                _buildTopBar(context, user.avatarUrl, user.name),
                _buildSearchBar(),
                _buildFilterChips(profileState),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: _buildTabContent(profileState),
          ),
          // Pin count summary
          if (profileState.activeTab == ProfileTab.pins &&
              profileState.savedPins.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: Text(
                    '${profileState.savedPins.length} Pin${profileState.savedPins.length == 1 ? '' : 's'} saved',
                    style: AppTypography.labelMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, String? avatarUrl, String? name) {
    final profileState = ref.watch(profileNotifierProvider);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.paddingLarge,
        AppDimensions.paddingSmall,
        AppDimensions.paddingLarge,
        0,
      ),
      child: Row(
        children: [
          // Avatar → opens Your Account
          AvatarWidget(
            size: 36,
            imageUrl: avatarUrl,
            name: name ?? 'U',
            onTap: () => context.push('/profile/settings'),
          ),
          const SizedBox(width: 12),
          // Tabs: Pins / Boards / Collages
          Expanded(
            child: Row(
              children: [
                _TopTab(
                  label: 'Pins',
                  isActive: profileState.activeTab == ProfileTab.pins,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    ref.read(profileNotifierProvider.notifier).changeTab(ProfileTab.pins);
                  },
                ),
                const SizedBox(width: 20),
                _TopTab(
                  label: 'Boards',
                  isActive: profileState.activeTab == ProfileTab.boards,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    ref.read(profileNotifierProvider.notifier).changeTab(ProfileTab.boards);
                  },
                ),
                const SizedBox(width: 20),
                _TopTab(
                  label: 'Collages',
                  isActive: profileState.activeTab == ProfileTab.collages,
                  onTap: () {
                    HapticFeedback.lightImpact();
                    ref.read(profileNotifierProvider.notifier).changeTab(ProfileTab.collages);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.paddingLarge,
        12,
        AppDimensions.paddingLarge,
        8,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.lightGray,
                borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
                border: Border.all(color: AppColors.divider, width: 1),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  const Icon(Icons.search, color: AppColors.textSecondary, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Search your Pins',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: AppColors.scaffoldBg,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add, color: AppColors.textPrimary, size: 28),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(ProfileState profileState) {
    if (profileState.activeTab != ProfileTab.pins) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.paddingLarge,
        0,
        AppDimensions.paddingLarge,
        8,
      ),
      child: Row(
        children: [
          _FilterChip(
            child: const Icon(Icons.grid_view_rounded, size: 18, color: AppColors.textPrimary),
            onTap: () {},
          ),
          const SizedBox(width: 8),
          _FilterChip(
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star_rounded, size: 18, color: AppColors.textPrimary),
                SizedBox(width: 4),
                Text('Favourites', style: AppTypography.labelSmall),
              ],
            ),
            onTap: () {},
          ),
          const SizedBox(width: 8),
          _FilterChip(
            child: const Text('Created by you', style: AppTypography.labelSmall),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent(ProfileState profileState) {
    switch (profileState.activeTab) {
      case ProfileTab.pins:
        return _buildPinsTab(profileState);
      case ProfileTab.boards:
        return const SavedBoardsGrid();
      case ProfileTab.collages:
        return const SizedBox(
          height: 240,
          child: AppErrorWidget(
            icon: Icons.collections_outlined,
            message: 'No collages yet',
            subtitle: 'Create collages to see them here.',
          ),
        );
    }
  }

  Widget _buildPinsTab(ProfileState profileState) {
    if (profileState.savedPins.isEmpty) {
      return const SizedBox(
        height: 240,
        child: AppErrorWidget(
          icon: Icons.bookmark_border_rounded,
          message: 'No saved pins yet',
          subtitle: 'Save pins from the home feed to see them here.',
        ),
      );
    }
    return const CreatedPinsGrid();
  }
}

// single tab button (Pins / Boards / Collages) with the underline indicator
class _TopTab extends StatelessWidget {
  const _TopTab({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTypography.labelMedium.copyWith(
              color: isActive ? AppColors.textPrimary : AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            height: 2.5,
            width: label.length * 7.5,
            decoration: BoxDecoration(
              color: isActive ? AppColors.textPrimary : Colors.transparent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}

// rounded chip for filter options like Favourites etc
class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.child,
    required this.onTap,
  });

  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.lightGray,
          borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
        ),
        child: Center(child: child),
      ),
    );
  }
}