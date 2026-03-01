import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScrollDirectionNotifier extends StateNotifier<ScrollDirection> {
  ScrollDirectionNotifier() : super(ScrollDirection.idle);

  void update(ScrollDirection direction) {
    if (direction == state) return;
    state = direction;
  }

  bool get isScrollingDown => state == ScrollDirection.reverse;
  bool get isScrollingUp => state == ScrollDirection.forward;
}

final scrollDirectionProvider =
    StateNotifierProvider<ScrollDirectionNotifier, ScrollDirection>((ref) {
  return ScrollDirectionNotifier();
});

// True when the bottom nav should be visible (scrolling up or idle)
final isBottomNavVisibleProvider = Provider<bool>((ref) {
  final direction = ref.watch(scrollDirectionProvider);
  return direction != ScrollDirection.reverse;
});
