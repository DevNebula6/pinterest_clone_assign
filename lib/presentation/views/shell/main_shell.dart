import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../create/create_pin_view.dart';
import 'widgets/bottom_navigation.dart';

class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  bool _isNavVisible = true;

  void _onItemTapped(int visualIndex) {
    if (visualIndex == 2) {
      _showCreateModal();
      return;
    }
    final branchIndex = BottomNavigation.visualToBranch(visualIndex);
    widget.shell.goBranch(
      branchIndex,
      initialLocation: branchIndex == widget.shell.currentIndex,
    );
  }

  void _showCreateModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const CreatePinView(),
    );
  }

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification is UserScrollNotification) {
      final direction = notification.direction;
      if (direction == ScrollDirection.reverse && _isNavVisible) {
        setState(() => _isNavVisible = false);
      } else if (direction == ScrollDirection.forward && !_isNavVisible) {
        setState(() => _isNavVisible = true);
      }
    }
    // Return false so the notification keeps bubbling.
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      extendBody: true,
      body: NotificationListener<ScrollNotification>(
        onNotification: _onScrollNotification,
        child: widget.shell,
      ),
      bottomNavigationBar: BottomNavigation(
        currentBranchIndex: widget.shell.currentIndex,
        onItemTapped: _onItemTapped,
        isVisible: _isNavVisible,
      ),
    );
  }
}
