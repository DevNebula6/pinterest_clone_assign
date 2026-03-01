import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// helper class for all the page transitions
class RouteTransitions {
  RouteTransitions._();

  // simple fade, used for most screens
  static Page<T> fade<T>({
    required LocalKey key,
    required Widget child,
    String? name,
    Object? arguments,
    String? restorationId,
  }) {
    return CustomTransitionPage<T>(
      key: key,
      name: name,
      arguments: arguments,
      restorationId: restorationId,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  // slides up from the bottom, good for modals
  static Page<T> slideUp<T>({
    required LocalKey key,
    required Widget child,
    String? name,
    Object? arguments,
    String? restorationId,
  }) {
    return CustomTransitionPage<T>(
      key: key,
      name: name,
      arguments: arguments,
      restorationId: restorationId,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween(
          begin: const Offset(0.0, 1.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeOutCubic));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }

  // slides in from right, used for detail screens - also supports hero animations
  static Page<T> slideRight<T>({
    required LocalKey key,
    required Widget child,
    String? name,
    Object? arguments,
    String? restorationId,
  }) {
    return CustomTransitionPage<T>(
      key: key,
      name: name,
      arguments: arguments,
      restorationId: restorationId,
      transitionDuration: const Duration(milliseconds: 300),
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeOutCubic));
        final fade = Tween<double>(begin: 0.0, end: 1.0);
        return FadeTransition(
          opacity: animation.drive(fade),
          child: SlideTransition(position: animation.drive(tween), child: child),
        );
      },
    );
  }

  // no animation, used for the splash/initial screen
  static Page<T> none<T>({
    required LocalKey key,
    required Widget child,
    String? name,
  }) {
    return CustomTransitionPage<T>(
      key: key,
      name: name,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) => child,
    );
  }
}
