import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../presentation/notifiers/auth_state.dart';
import '../presentation/providers/auth_providers.dart';
import '../presentation/providers/core_providers.dart';
import '../presentation/views/auth/login_view.dart';
import '../presentation/views/auth/password_login_view.dart';
import '../presentation/views/auth/signup_view.dart';

import '../presentation/views/board_detail/board_detail_view.dart';
import '../presentation/views/home/home_view.dart';
import '../presentation/views/notifications/notifications_view.dart';
import '../presentation/views/onboarding/onboarding_view.dart';
import '../presentation/views/pin_detail/pin_detail_view.dart';
import '../presentation/views/profile/profile_view.dart';
import '../presentation/views/search/search_view.dart';
import '../presentation/views/settings/edit_profile_view.dart';
import '../presentation/views/settings/settings_view.dart';
import '../presentation/views/shell/main_shell.dart';
import '../presentation/views/splash/splash_view.dart';
import 'route_names.dart';
import 'route_paths.dart';
import 'route_transitions.dart';

// watches auth state so the router knows when to redirect
class _RouterNotifier extends ChangeNotifier {
  _RouterNotifier(this._ref) {
    _ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      if (previous?.status != next.status) {
        notifyListeners();
      }
    });
  }

  final Ref _ref;
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final notifier = _RouterNotifier(ref);

  return GoRouter(
    initialLocation: RoutePaths.splash,
    debugLogDiagnostics: true,
    refreshListenable: notifier,
    redirect: (context, state) {
      final authState = ref.read(authNotifierProvider);
      final location = state.uri.toString();

      final isSplash = location == RoutePaths.splash;
      final isLogin = location == RoutePaths.login;
      final isSignup = location == RoutePaths.signup;
      final isOnboarding = location == RoutePaths.onboarding;
      final isLoginPassword = location == RoutePaths.loginPassword;
      final isAuthRoute =
          isSplash || isLogin || isSignup || isOnboarding || isLoginPassword;
      // these routes are ok to visit when not logged in
      final isUnauthRoute = isLogin || isSignup || isLoginPassword;

      if (authState.isUnknown) {
        return isSplash ? null : RoutePaths.splash;
      }

      if (authState.isUnauthenticated) {
        return isUnauthRoute ? null : RoutePaths.login;
      }

      // ── Authenticated ──
      // read onboarding flag from prefs (already loaded at startup so this is fast)
      final prefs = ref.read(sharedPreferencesProvider);
      final hasOnboarded = prefs.getBool(kOnboardingCompleteKey) ?? false;

      if (!hasOnboarded) {
        // new user, needs to complete onboarding first
        return isOnboarding ? null : RoutePaths.onboarding;
      }

      // already did onboarding, dont let them go back to login/signup
      if (isAuthRoute) return RoutePaths.home;
      return null;
    },
    routes: [
      // Splash — no bottom nav, shown at startup
      GoRoute(
        path: RoutePaths.splash,
        name: RouteNames.splash,
        pageBuilder: (context, state) => RouteTransitions.none(
          key: state.pageKey,
          child: const SplashView(),
          name: RouteNames.splash,
        ),
      ),

      // Login landing screen
      GoRoute(
        path: RoutePaths.login,
        name: RouteNames.login,
        pageBuilder: (context, state) => RouteTransitions.fade(
          key: state.pageKey,
          child: const LoginView(),
          name: RouteNames.login,
        ),
      ),

      // Password login — slides in from the landing screen
      GoRoute(
        path: RoutePaths.loginPassword,
        name: RouteNames.loginPassword,
        pageBuilder: (context, state) {
          final email = (state.extra as String?) ?? '';
          return RouteTransitions.slideRight(
            key: state.pageKey,
            child: PasswordLoginView(email: email),
            name: RouteNames.loginPassword,
          );
        },
      ),

      // Sign up — outside the shell
      GoRoute(
        path: RoutePaths.signup,
        name: RouteNames.signup,
        pageBuilder: (context, state) => RouteTransitions.fade(
          key: state.pageKey,
          child: const SignupView(),
          name: RouteNames.signup,
        ),
      ),

      // Onboarding — country, interests, tuning feed
      GoRoute(
        path: RoutePaths.onboarding,
        name: RouteNames.onboarding,
        pageBuilder: (context, state) => RouteTransitions.fade(
          key: state.pageKey,
          child: const OnboardingView(),
          name: RouteNames.onboarding,
        ),
      ),

      // Main shell with bottom navigation (4 branches)
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => MainShell(shell: shell),
        branches: [
          // Branch 0: Home
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.home,
                name: RouteNames.home,
                pageBuilder: (context, state) => RouteTransitions.fade(
                  key: state.pageKey,
                  child: const HomeView(),
                  name: RouteNames.home,
                ),
                routes: [
                  GoRoute(
                    path: RoutePaths.pinDetail,
                    name: RouteNames.pinDetail,
                    pageBuilder: (context, state) {
                      final id = int.tryParse(
                            state.pathParameters['id'] ?? '',
                          ) ??
                          0;
                      return RouteTransitions.slideRight(
                        key: state.pageKey,
                        child: PinDetailView(pinId: id),
                        name: RouteNames.pinDetail,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),

          // Branch 1: Search
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.search,
                name: RouteNames.search,
                pageBuilder: (context, state) => RouteTransitions.fade(
                  key: state.pageKey,
                  child: const SearchView(),
                  name: RouteNames.search,
                ),
                routes: [
                  GoRoute(
                    path: RoutePaths.searchPinDetail,
                    name: RouteNames.searchPinDetail,
                    pageBuilder: (context, state) {
                      final id = int.tryParse(
                            state.pathParameters['id'] ?? '',
                          ) ??
                          0;
                      return RouteTransitions.slideRight(
                        key: state.pageKey,
                        child: PinDetailView(pinId: id),
                        name: RouteNames.searchPinDetail,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),

          // Branch 2: Notifications
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.notifications,
                name: RouteNames.notifications,
                pageBuilder: (context, state) => RouteTransitions.fade(
                  key: state.pageKey,
                  child: const NotificationsView(),
                  name: RouteNames.notifications,
                ),
              ),
            ],
          ),

          // Branch 3: Profile
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RoutePaths.profile,
                name: RouteNames.profile,
                pageBuilder: (context, state) => RouteTransitions.fade(
                  key: state.pageKey,
                  child: const ProfileView(),
                  name: RouteNames.profile,
                ),
                routes: [
                  GoRoute(
                    path: RoutePaths.boardDetail,
                    name: RouteNames.boardDetail,
                    pageBuilder: (context, state) {
                      final boardId = state.pathParameters['id'] ?? '';
                      return RouteTransitions.slideRight(
                        key: state.pageKey,
                        child: BoardDetailView(boardId: boardId),
                        name: RouteNames.boardDetail,
                      );
                    },
                  ),
                  GoRoute(
                    path: RoutePaths.settings,
                    name: RouteNames.settings,
                    pageBuilder: (context, state) => RouteTransitions.slideRight(
                      key: state.pageKey,
                      child: const SettingsView(),
                      name: RouteNames.settings,
                    ),
                  ),
                  GoRoute(
                    path: RoutePaths.editProfile,
                    name: RouteNames.editProfile,
                    pageBuilder: (context, state) => RouteTransitions.slideRight(
                      key: state.pageKey,
                      child: const EditProfileView(),
                      name: RouteNames.editProfile,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
