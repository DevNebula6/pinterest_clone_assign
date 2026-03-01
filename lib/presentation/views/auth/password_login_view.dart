import 'dart:async';

import 'package:clerk_auth/clerk_auth.dart' as clerk;
import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../domain/entities/user.dart' as entities;
import '../../../presentation/providers/auth_providers.dart';
import '../../../presentation/providers/core_providers.dart';
import '../../../presentation/views/onboarding/onboarding_view.dart';
import '../../../router/route_paths.dart';
import 'widgets/google_logo.dart';

// second step of login - user gets here after entering email on the first screen
class PasswordLoginView extends ConsumerStatefulWidget {
  const PasswordLoginView({super.key, required this.email});

  final String email;

  @override
  ConsumerState<PasswordLoginView> createState() => _PasswordLoginViewState();
}

class _PasswordLoginViewState extends ConsumerState<PasswordLoginView> {
  late final TextEditingController _emailController;
  final _passwordController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  late final ClerkAuthState _clerkState;
  StreamSubscription<dynamic>? _errorSub;
  bool _loading = false;
  bool _obscurePassword = true;

  // --- lifecycle ---

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.email);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _clerkState = ClerkAuth.of(context, listen: false);
      _clerkState.addListener(_onClerkStateChanged);
      _errorSub = _clerkState.errorStream.listen(_onClerkError);
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _clerkState.removeListener(_onClerkStateChanged);
    _errorSub?.cancel();
    super.dispose();
  }

  // --- clerk callbacks ---

  void _onClerkStateChanged() {
    if (!mounted) return;
    if (_clerkState.isSignedIn) _syncToRiverpodAndNavigate();
    setState(() => _loading = false);
  }

  void _onClerkError(clerk.ClerkError error) {
    if (!mounted) return;
    setState(() => _loading = false);
    final msg = error.argument ?? error.message;
    ScaffoldMessenger.of(_scaffoldKey.currentContext ?? context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: AppColors.pinterestRed,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _syncToRiverpodAndNavigate() {
    if (!mounted) return;
    ref.read(sharedPreferencesProvider).setBool(kOnboardingCompleteKey, true);
    final u = _clerkState.user;
    ref.read(authNotifierProvider.notifier).setAuthenticatedUser(
          entities.User(
            id: u?.id ?? 'clerk',
            name: '${u?.firstName ?? ''} ${u?.lastName ?? ''}'.trim().isEmpty
                ? 'Pinterest User'
                : '${u?.firstName ?? ''} ${u?.lastName ?? ''}'.trim(),
            username: u?.username ?? 'user',
            email: u?.email ?? '',
            avatarUrl: u?.profileImageUrl,
          ),
        );
  }

  // --- actions ---

  Future<void> _signInWithEmailPassword() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your email and password.'),
        ),
      );
      return;
    }
    setState(() => _loading = true);
    await _clerkState.safelyCall(
      context,
      () => _clerkState.attemptSignIn(
        strategy: clerk.Strategy.password,
        identifier: email,
        password: password,
      ),
    );
  }

  Future<void> _signInWithGoogle() async {
    clerk.Strategy? googleStrategy;
    try {
      googleStrategy = _clerkState.env.strategies.firstWhere(
        (s) =>
            s.provider?.toLowerCase() == 'google' ||
            s.name.toLowerCase().contains('google'),
      );
    } catch (_) {
      googleStrategy = null;
    }
    if (googleStrategy == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Google sign-in is not configured.')),
      );
      return;
    }
    try {
      await _clerkState.ssoSignIn(context, googleStrategy);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: AppColors.pinterestRed,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // --- build ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.white,
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.translucent,
        child: SafeArea(
          child: Column(
          children: [
            // top bar with the close button and title
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingSmall,
                vertical: AppDimensions.paddingSmall,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.close, size: 24),
                    padding: EdgeInsets.zero,
                    constraints:
                        const BoxConstraints(minWidth: 40, minHeight: 40),
                  ),
                  const Expanded(
                    child: Text(
                      'Log in',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 40), // balance icon
                ],
              ),
            ),

            const Divider(height: 1, color: AppColors.divider),

            // main content area
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingXLarge,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 28),

                    // Continue with Google
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        onPressed: _loading ? null : _signInWithGoogle,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: AppColors.divider,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusRound,
                            ),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GoogleLogo(size: 22),
                            SizedBox(width: 10),
                            Text(
                              'Continue with Google',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Or
                    const Text(
                      'Or',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Email field (pre-filled)
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      autocorrect: false,
                      enableSuggestions: false,
                      decoration: InputDecoration(
                        hintText: 'Email address',
                        hintStyle: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 16,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusRound,
                          ),
                          borderSide: const BorderSide(
                            color: AppColors.divider,
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusRound,
                          ),
                          borderSide: const BorderSide(
                            color: AppColors.textPrimary,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Password field
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.done,
                      autocorrect: false,
                      enableSuggestions: false,
                      onSubmitted: (_) => _signInWithEmailPassword(),
                      decoration: InputDecoration(
                        hintText: 'Enter your password',
                        hintStyle: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 16,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: AppColors.textPrimary,
                          ),
                          onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusRound,
                          ),
                          borderSide: const BorderSide(
                            color: AppColors.divider,
                            width: 1.5,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusRound,
                          ),
                          borderSide: const BorderSide(
                            color: AppColors.textPrimary,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Log in button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed:
                            _loading ? null : _signInWithEmailPassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.pinterestRed,
                          foregroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusRound,
                            ),
                          ),
                          elevation: 0,
                        ),
                        child: _loading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.white,
                                ),
                              )
                            : const Text(
                                'Log in',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Forgotten password
                    GestureDetector(
                      onTap: () {
                        // Stub — could navigate to a forgot-password flow
                      },
                      child: const Text(
                        'Forgotten password?',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Sign up link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account? ",
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => context.go(RoutePaths.signup),
                          child: const Text(
                            'Sign up',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.pinterestRed,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}
