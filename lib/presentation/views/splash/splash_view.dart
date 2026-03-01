import 'dart:async';

import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../../../domain/entities/user.dart' as entities;
import '../../../presentation/providers/auth_providers.dart';

class SplashView extends ConsumerStatefulWidget {
  const SplashView({super.key});

  @override
  ConsumerState<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends ConsumerState<SplashView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnim;
  late final Animation<double> _scaleAnim;
  late final ClerkAuthState _clerkState;
  StreamSubscription<dynamic>? _errorSub;
  Timer? _timeoutTimer;
  Timer? _sessionGraceTimer;
  bool _syncDone = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.6)),
    );
    _scaleAnim = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _controller.forward();

    // wait for the first frame before accessing clerk, otherwise InheritedWidget isnt ready yet
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _clerkState = ClerkAuth.of(context, listen: false);
      _clerkState.addListener(_onClerkStateChanged);
      // supress errors during splash, nothing to display them on anyway
      _errorSub = _clerkState.errorStream.listen((_) {});
      // sdk might already be ready if this is a hot reload
      if (!_clerkState.isNotAvailable) {
        _onSdkReady();
        return;
      }
      // safety net - if clerk never loads (bad network etc.) just go to login after 6s
      _timeoutTimer = Timer(const Duration(seconds: 6), () {
        if (!mounted || _syncDone) return;
        ref.read(authNotifierProvider.notifier).setUnauthenticated();
        _syncDone = true;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _clerkState.removeListener(_onClerkStateChanged);
    _errorSub?.cancel();
    _timeoutTimer?.cancel();
    _sessionGraceTimer?.cancel();
    super.dispose();
  }

  void _onClerkStateChanged() {
    if (!mounted || _syncDone) return;

    // if user is already signed in, no need to wait around
    if (_clerkState.isSignedIn) {
      _sessionGraceTimer?.cancel();
      _timeoutTimer?.cancel();
      _syncAuthToRiverpod();
      return;
    }

    // sdk is ready but not signed in, give it a moment in case the session is still loading
    if (!_clerkState.isNotAvailable) {
      _onSdkReady();
    }
  }

  // called once clerk sdk is available
  void _onSdkReady() {
    if (_syncDone) return;

    // already logged in, good to go
    if (_clerkState.isSignedIn) {
      _timeoutTimer?.cancel();
      _syncAuthToRiverpod();
      return;
    }

    // not signed in yet - wait a bit before giving up, clerk might still restore the session
    if (_sessionGraceTimer == null || !_sessionGraceTimer!.isActive) {
      _sessionGraceTimer = Timer(const Duration(seconds: 3), () {
        if (!mounted || _syncDone) return;
        // waited long enough, not signed in so go to login
        _syncAuthToRiverpod();
      });
    }
  }

  // sync clerk session into riverpod so the router can redirect properly
  void _syncAuthToRiverpod() {
    if (!mounted || _syncDone) return;
    _syncDone = true;

    if (_clerkState.isSignedIn) {
      final u = _clerkState.user;
      final appUser = entities.User(
        id: u?.id ?? 'clerk',
        name: '${u?.firstName ?? ''} ${u?.lastName ?? ''}'.trim(),
        email: u?.email ?? '',
        avatarUrl: u?.profileImageUrl,
      );
      ref.read(authNotifierProvider.notifier).setAuthenticatedUser(appUser);
    } else {
      ref.read(authNotifierProvider.notifier).setUnauthenticated();
    }
    // GoRouter's redirect function handles the actual navigation.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: ScaleTransition(
            scale: _scaleAnim,
            child: const _PinterestLogo(),
          ),
        ),
      ),
    );
  }
}

class _PinterestLogo extends StatelessWidget {
  const _PinterestLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: const BoxDecoration(
        color: AppColors.pinterestRed,
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Text(
          'P',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 48,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
