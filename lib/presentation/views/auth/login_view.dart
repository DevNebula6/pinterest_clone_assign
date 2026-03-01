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
import 'widgets/animated_collage.dart';
import 'widgets/google_logo.dart';

// landing/login screen with the animated collage, email field and google SSO button
class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final _emailController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  late final ClerkAuthState _clerkState;
  StreamSubscription<dynamic>? _errorSub;
  bool _loading = false;

  // --- lifecycle ---

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _clerkState = ClerkAuth.of(context, listen: false);
      _clerkState.addListener(_onClerkStateChanged);
      _errorSub = _clerkState.errorStream.listen(_onClerkError);
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
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

  // actions

  void _onContinuePressed() {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email address.')),
      );
      return;
    }
    context.push(RoutePaths.loginPassword, extra: email);
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
        const SnackBar(
          content: Text('Google sign-in is not configured.'),
        ),
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

  // build

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final collageHeight = screenHeight * 0.42;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.white,
      resizeToAvoidBottomInset: true,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.translucent,
        child: Column(
        children: [
          // Animated image collage
          SizedBox(
            height: collageHeight,
            width: double.infinity,
            child: const AnimatedCollage(),
          ),

          // Scrollable content below the collage
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.paddingXLarge,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  _buildLogo(),
                  const SizedBox(height: 16),

                  // Headline
                  const Text(
                    'Create a life\nyou love',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Email field
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    autocorrect: false,
                    enableSuggestions: false,
                    onSubmitted: (_) => _onContinuePressed(),
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
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusRound),
                        borderSide: const BorderSide(
                          color: AppColors.divider,
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusRound),
                        borderSide: const BorderSide(
                          color: AppColors.textPrimary,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Continue button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _onContinuePressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.pinterestRed,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppDimensions.radiusRound),
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
                              'Continue',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),

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
                          borderRadius:
                              BorderRadius.circular(AppDimensions.radiusRound),
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
                  const SizedBox(height: 20),

                  // Terms footer
                  RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        height: 1.5,
                      ),
                      children: [
                        TextSpan(
                            text:
                                "By continuing, you agree to Pinterest's "),
                        TextSpan(
                          text: 'Terms of Service',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(
                            text:
                                " and acknowledge that you've read our "),
                        TextSpan(
                          text: 'Privacy Policy',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(text: '. '),
                        TextSpan(
                          text: 'Notice at collection',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(text: '.'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildLogo() {
    return Container(
      width: 48,
      height: 48,
      decoration: const BoxDecoration(
        color: AppColors.pinterestRed,
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Text(
          'P',
          style: TextStyle(
            color: AppColors.white,
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
