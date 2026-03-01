import 'dart:async';

import 'package:clerk_auth/clerk_auth.dart' as clerk;
import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_strings.dart';
import '../../../domain/entities/user.dart' as entities;
import '../../../presentation/providers/auth_providers.dart';
import '../../../router/route_paths.dart';

class SignupView extends ConsumerStatefulWidget {
  const SignupView({super.key});

  @override
  ConsumerState<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends ConsumerState<SignupView> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  late final ClerkAuthState _clerkState;
  StreamSubscription<dynamic>? _errorSub;
  bool _loading = false;
  bool _obscurePassword = true;


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
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _clerkState.removeListener(_onClerkStateChanged);
    _errorSub?.cancel();
    super.dispose();
  }

  void _onClerkStateChanged() {
    if (!mounted) return;
    debugPrint('[Auth][Signup] state change '
        'isSignedIn=${_clerkState.isSignedIn} '
        'isSigningUp=${_clerkState.isSigningUp} '
        'isNotAvailable=${_clerkState.isNotAvailable}');
    setState(() => _loading = false);

    if (_clerkState.isSignedIn) {
      _syncToRiverpodAndNavigate();
    }
  }

  void _onClerkError(clerk.ClerkError error) {
    if (!mounted) return;
    setState(() => _loading = false);

    final displayMessage = error.argument ?? error.message;
    debugPrint('[Auth][Signup] ClerkError '
        'code=${error.code.name} | $displayMessage '
        '${error.errors?.errors?.map((e) => e.fullMessage).join(" | ") ?? ""}');

    ScaffoldMessenger.of(_scaffoldKey.currentContext ?? context).showSnackBar(
      SnackBar(
        content: Text(displayMessage),
        backgroundColor: AppColors.pinterestRed,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _syncToRiverpodAndNavigate() {
    if (!mounted) return;
    final u = _clerkState.user;
    ref.read(authNotifierProvider.notifier).setAuthenticatedUser(
          entities.User(
            id: u?.id ?? 'clerk',
            name: '${u?.firstName ?? ''} ${u?.lastName ?? ''}'.trim(),
            username: u?.username ?? 'user',
            email: u?.email ?? '',
            avatarUrl: u?.profileImageUrl,
          ),
        );
  }

  Future<void> _signUpWithEmailPassword() async {
    final fullName = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (fullName.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }

    // Split "First Last" → firstName + lastName (remainder).
    final parts = fullName.split(' ');
    final firstName = parts.first;
    final lastName = parts.length > 1 ? parts.skip(1).join(' ') : '';

    setState(() => _loading = true);
    try {
      await _clerkState.attemptSignUp(
        strategy: clerk.Strategy.emailCode,
        emailAddress: email,
        password: password,
        passwordConfirmation: password,
        firstName: firstName,
        lastName: lastName.isNotEmpty ? lastName : null,
      );
    } on clerk.ClerkError catch (error) {
      _onClerkError(error);
    } catch (e) {
      if (mounted) setState(() => _loading = false);
      debugPrint('[Auth][Signup] unexpected error: $e');
    }
  }

  Future<void> _signUpWithGoogle() async {
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
          content: Text('Google sign-in is not configured in your Clerk Dashboard.'),
        ),
      );
      return;
    }

    try {
      await _clerkState.ssoSignUp(context, googleStrategy);
    } catch (e) {
      if (!mounted) return;
      debugPrint('[Auth][Signup] ssoSignUp error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: AppColors.pinterestRed,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.paddingXLarge,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 48),
              Center(child: _buildLogo()),
              const SizedBox(height: 24),
              Text(
                'Create an account',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Find new ideas to try',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(hintText: 'Your name'),
              ),
              const SizedBox(height: AppDimensions.paddingMedium),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autocorrect: false,
                enableSuggestions: false,
                decoration: const InputDecoration(hintText: AppStrings.email),
              ),
              const SizedBox(height: AppDimensions.paddingMedium),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.done,
                autocorrect: false,
                enableSuggestions: false,
                onSubmitted: (_) => _signUpWithEmailPassword(),
                decoration: InputDecoration(
                  hintText: AppStrings.password,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.paddingXLarge),
              ElevatedButton(
                onPressed: _loading ? null : _signUpWithEmailPassword,
                child: _loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.white,
                        ),
                      )
                    : const Text(AppStrings.signUp),
              ),
              const SizedBox(height: AppDimensions.paddingLarge),
              const _Divider(),
              const SizedBox(height: AppDimensions.paddingLarge),
              OutlinedButton.icon(
                onPressed: _loading ? null : _signUpWithGoogle,
                icon: const _GoogleIcon(),
                label: const Text(AppStrings.continueWithGoogle),
              ),
              const SizedBox(height: AppDimensions.paddingMedium),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(color: AppColors.textSecondary),
                  ),
                  TextButton(
                    onPressed:
                        _loading ? null : () => context.go(RoutePaths.login),
                    child: const Text(
                      AppStrings.signIn,
                      style: TextStyle(
                        color: AppColors.pinterestRed,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
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

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: Divider()),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingMedium),
          child: Text('or', style: TextStyle(color: AppColors.textSecondary)),
        ),
        Expanded(child: Divider()),
      ],
    );
  }
}

class _GoogleIcon extends StatelessWidget {
  const _GoogleIcon();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 20,
      height: 20,
      child: CircleAvatar(
        backgroundColor: Color(0xFF4285F4),
        child: Text(
          'G',
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

