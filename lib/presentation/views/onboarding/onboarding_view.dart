import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../presentation/providers/core_providers.dart';
import '../../../router/route_paths.dart';
import 'country_page.dart';
import 'dob_page.dart';
import 'gender_page.dart';
import 'interests_page.dart';
import 'tuning_feed_page.dart';

// shared prefs key to remmeber if user finished onboarding
const kOnboardingCompleteKey = 'has_completed_onboarding';

class OnboardingView extends ConsumerStatefulWidget {
  const OnboardingView({super.key});

  @override
  ConsumerState<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends ConsumerState<OnboardingView> {
  final _pageController = PageController();
  int _currentPage = 0;

  static const _pageCount = 4; // country, dob, gender, interests

  bool _showTuningFeed = false; // when true we swap to the card-spinning animation

  // ── State ──────────────────────────────────────────────────────────
  String _selectedCountry = 'India';
  DateTime? _dateOfBirth;
  String _selectedGender = 'Prefer not to say';
  final Set<String> _selectedInterests = {};

  bool get _canProceed {
    switch (_currentPage) {
      case 0: // Country — always has a default.
        return true;
      case 1: // DOB — always allow (optional in real Pinterest).
        return true;
      case 2: // Gender — always allow (has a default).
        return true;
      case 3: // Interests — need at least 3.
        return _selectedInterests.length >= 3;
      default:
        return false;
    }
  }

  void _nextPage() {
    if (!_canProceed) return;

    if (_currentPage < _pageCount - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
    } else {
      // Last page (interests) → show tuning feed overlay.
      setState(() => _showTuningFeed = true);
    }
  }

  Future<void> _completeOnboarding() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(kOnboardingCompleteKey, true);

    if (!mounted) return;
    context.go(RoutePaths.home);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ── Tuning feed takes over the full screen ─────────────────────
    if (_showTuningFeed) {
      return Scaffold(
        backgroundColor: AppColors.white,
        body: SafeArea(
          child: TuningFeedPage(
            selectedInterests: _selectedInterests.toList(),
            onComplete: _completeOnboarding,
          ),
        ),
      );
    }

    // ── Pages 0-3: country → DOB → gender → interests ─────────────
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            _PageDots(current: _currentPage, total: _pageCount),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (page) => setState(() => _currentPage = page),
                children: [
                  // Page 0: Date of birth
                  DobPage(
                    dateOfBirth: _dateOfBirth,
                    onDateOfBirthSelected: (d) =>
                        setState(() => _dateOfBirth = d),
                  ),
                  // Page 1: Gender
                  GenderPage(
                    selectedGender: _selectedGender,
                    onGenderSelected: (g) =>
                        setState(() => _selectedGender = g),
                  ),
                  // Page 2: Country
                  CountryPage(
                    selectedCountry: _selectedCountry,
                    onCountrySelected: (c) =>
                        setState(() => _selectedCountry = c),
                  ),
                  // Page 3: Interests
                  InterestsPage(
                    selected: _selectedInterests,
                    onToggle: (label) {
                      setState(() {
                        if (_selectedInterests.contains(label)) {
                          _selectedInterests.remove(label);
                        } else {
                          _selectedInterests.add(label);
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
            // ── Next button ────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.paddingXLarge,
                8,
                AppDimensions.paddingXLarge,
                16,
              ),
              child: SizedBox(
                width: double.infinity,
                height: AppDimensions.buttonHeight,
                child: ElevatedButton(
                  onPressed: _canProceed ? _nextPage : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _canProceed
                        ? AppColors.pinterestRed
                        : AppColors.buttonGray,
                    foregroundColor: _canProceed
                        ? AppColors.white
                        : AppColors.textTertiary,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusRound),
                    ),
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// dot indicator for the onboarding pages
class _PageDots extends StatelessWidget {
  const _PageDots({required this.current, required this.total});

  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (i) {
        final isActive = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? AppColors.textPrimary : AppColors.divider,
          ),
        );
      }),
    );
  }
}
