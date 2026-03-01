import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomNavState {
  const BottomNavState({
    this.currentIndex = 0,
    this.isVisible = true,
  });

  final int currentIndex;
  final bool isVisible;

  BottomNavState copyWith({int? currentIndex, bool? isVisible}) {
    return BottomNavState(
      currentIndex: currentIndex ?? this.currentIndex,
      isVisible: isVisible ?? this.isVisible,
    );
  }
}

class BottomNavController extends StateNotifier<BottomNavState> {
  BottomNavController() : super(const BottomNavState());

  void setIndex(int index) {
    if (index == state.currentIndex) return;
    state = state.copyWith(currentIndex: index);
  }

  void show() {
    if (state.isVisible) return;
    state = state.copyWith(isVisible: true);
  }

  void hide() {
    if (!state.isVisible) return;
    state = state.copyWith(isVisible: false);
  }

  void toggleVisibility() {
    state = state.copyWith(isVisible: !state.isVisible);
  }
}

final bottomNavControllerProvider =
    StateNotifierProvider<BottomNavController, BottomNavState>((ref) {
  return BottomNavController();
});

// Convenience selectors
final currentNavIndexProvider = Provider<int>((ref) {
  return ref.watch(bottomNavControllerProvider).currentIndex;
});

final isNavBarVisibleProvider = Provider<bool>((ref) {
  return ref.watch(bottomNavControllerProvider).isVisible;
});
