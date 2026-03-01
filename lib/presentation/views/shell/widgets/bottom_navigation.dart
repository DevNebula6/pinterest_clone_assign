import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';

class _NavItem {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    this.isCreate = false,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isCreate;
}

const _navItems = [
  _NavItem(icon: Icons.home_outlined, activeIcon: Icons.home, label: 'Home'),
  _NavItem(icon: Icons.search, activeIcon: Icons.search, label: 'Search'),
  _NavItem(icon: Icons.add, activeIcon: Icons.add, label: '', isCreate: true),
  _NavItem(
      icon: Icons.chat_bubble_outline,
      activeIcon: Icons.chat_bubble,
      label: 'Inbox'),
  _NavItem(
      icon: Icons.person_outline, activeIcon: Icons.person, label: 'Saved'),
];

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({
    super.key,
    required this.currentBranchIndex,
    required this.onItemTapped,
    required this.isVisible,
  });

  // The currently active shell branch index (0-3, skipping the create slot).
  final int currentBranchIndex;
  // Called with the visual item index (0-4).
  final void Function(int visualIndex) onItemTapped;
  final bool isVisible;

  // Maps visual index (0-4) to branch index (skipping create at visual 2).
  static int visualToBranch(int visualIndex) {
    if (visualIndex < 2) return visualIndex;
    if (visualIndex > 2) return visualIndex - 1;
    return -1; // create
  }

  // Maps branch index (0-3) to visual index.
  static int branchToVisual(int branchIndex) {
    return branchIndex < 2 ? branchIndex : branchIndex + 1;
  }

  @override
  Widget build(BuildContext context) {
    final visualActive = branchToVisual(currentBranchIndex);

    return AnimatedSlide(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      offset: isVisible ? Offset.zero : const Offset(0.0, 1.0),
      child: Container(
        height:
            AppDimensions.bottomNavHeight + MediaQuery.of(context).padding.bottom,
        decoration: const BoxDecoration(
          color: AppColors.white,
          border: Border(
            top: BorderSide(color: AppColors.divider, width: 0.5),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: List.generate(_navItems.length, (i) {
              final item = _navItems[i];
              final isActive = i == visualActive;
              return Expanded(
                child: _NavItemButton(
                  icon: isActive ? item.activeIcon : item.icon,
                  label: item.label,
                  isActive: isActive,
                  isCreate: item.isCreate,
                  onTap: () => onItemTapped(i),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItemButton extends StatelessWidget {
  const _NavItemButton({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.isCreate,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final bool isCreate;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    if (isCreate) {
      return GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.textPrimary,
              borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
            ),
            child: const Icon(Icons.add, color: AppColors.white, size: 24),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      behavior: HitTestBehavior.opaque,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: AppDimensions.iconSmall + 4,
              color: isActive ? AppColors.textPrimary : AppColors.iconInactive,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color:
                    isActive ? AppColors.textPrimary : AppColors.iconInactive,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
