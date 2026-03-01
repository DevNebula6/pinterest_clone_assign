import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import 'onboarding_data.dart';

// the loading animation screen after the user picks interests - shows spinning cards and a progress bar
class TuningFeedPage extends StatefulWidget {
  const TuningFeedPage({
    super.key,
    required this.selectedInterests,
    required this.onComplete,
  });

  final List<String> selectedInterests;
  final VoidCallback onComplete;

  @override
  State<TuningFeedPage> createState() => _TuningFeedPageState();
}

class _TuningFeedPageState extends State<TuningFeedPage>
    with TickerProviderStateMixin {
  late final AnimationController _progressController;
  late final AnimationController _cardController;
  late final AnimationController _fadeController;

  int _messageIndex = 0;
  int _cardIndex = 0;

  List<String> get _imageUrls {
    // Build image URLs from selected interests.
    final selected = OnboardingData.interests
        .where((i) => widget.selectedInterests.contains(i.label))
        .toList();
    if (selected.isEmpty) {
      return List.generate(
          3, (i) => 'https://picsum.photos/seed/onboard$i/300/400');
    }
    return selected
        .map((i) => 'https://picsum.photos/seed/${i.query}/300/400')
        .toList();
  }

  @override
  void initState() {
    super.initState();

    // Progress bar — runs over 4.5 seconds total.
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4500),
    )..forward();

    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete();
      }
    });

    // Card rotation — cycles every 1.2 seconds.
    _cardController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // Fade for message text.
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: 1.0,
    );

    // Cycle cards and text every ~1.2s.
    _startCycling();
  }

  void _startCycling() {
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      _cycleNext();
      _startCycling();
    });
  }

  Future<void> _cycleNext() async {
    // Fade out text.
    await _fadeController.reverse();
    if (!mounted) return;

    setState(() {
      _messageIndex =
          (_messageIndex + 1) % OnboardingData.loadingMessages.length;
      _cardIndex = (_cardIndex + 1) % _imageUrls.length;
    });

    // Animate card.
    _cardController.forward(from: 0.0);
    // Fade in text.
    _fadeController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    _cardController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final urls = _imageUrls;

    return Column(
      children: [
        // Red progress bar at the top.
        AnimatedBuilder(
          animation: _progressController,
          builder: (_, __) {
            return LinearProgressIndicator(
              value: _progressController.value,
              backgroundColor: AppColors.lightGray,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.pinterestRed),
              minHeight: 4,
            );
          },
        ),
        const Spacer(flex: 2),
        // Rotating message text.
        FadeTransition(
          opacity: _fadeController,
          child: Text(
            OnboardingData.loadingMessages[_messageIndex],
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  height: 1.2,
                ),
          ),
        ),
        const SizedBox(height: 32),
        // Card carousel — 3-card stack with rotation animation.
        SizedBox(
          height: 320,
          width: double.infinity,
          child: AnimatedBuilder(
            animation: _cardController,
            builder: (_, __) {
              return Stack(
                alignment: Alignment.center,
                children: _buildCardStack(urls),
              );
            },
          ),
        ),
        const Spacer(flex: 1),
        // Pinterest logo.
        Container(
          width: 56,
          height: 56,
          decoration: const BoxDecoration(
            color: AppColors.pinterestRed,
            shape: BoxShape.circle,
          ),
          child: const Center(
            child: Text(
              'P',
              style: TextStyle(
                color: AppColors.white,
                fontSize: 32,
                fontWeight: FontWeight.w700,
                fontFamily: 'serif',
              ),
            ),
          ),
        ),
        const Spacer(flex: 2),
      ],
    );
  }

  List<Widget> _buildCardStack(List<String> urls) {
    if (urls.isEmpty) return [];

    final widgets = <Widget>[];

    // We show 3 cards in a fan: left, center, right.
    for (int offset = -1; offset <= 1; offset++) {
      final idx = (_cardIndex + offset + 1) % urls.length;
      final isCenter = offset == 0;

      // Animation: new center card scales up from 0.85 → 1.0.
      final scale = isCenter
          ? Tween<double>(begin: 0.85, end: 1.0)
              .animate(CurvedAnimation(
                  parent: _cardController, curve: Curves.easeOutBack))
              .value
          : 0.78;

      // Rotation for side cards.
      final angle = isCenter
          ? 0.0
          : offset * 0.08; // ~4.5 degrees

      // Horizontal offset.
      final dx = isCenter ? 0.0 : offset * 90.0;

      widgets.add(
        Transform(
          alignment: Alignment.bottomCenter,
          transform: Matrix4.identity()
            ..translateByDouble(dx, 0.0, 0.0, 1.0)
            ..rotateZ(angle)
            ..scaleByDouble(scale, scale, 1.0, 1.0),
          child: _CardImage(url: urls[idx], isCenter: isCenter),
        ),
      );
    }

    return widgets;
  }
}

class _CardImage extends StatelessWidget {
  const _CardImage({required this.url, required this.isCenter});

  final String url;
  final bool isCenter;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isCenter ? 220 : 200,
      height: isCenter ? 300 : 270,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          if (isCenter)
            const BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
          placeholder: (_, __) => Container(
            color: AppColors.lightGray,
            child: const Center(
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: AppColors.pinterestRed),
            ),
          ),
          errorWidget: (_, __, ___) => Container(
            color: AppColors.lightGray,
            child: const Icon(Icons.image_outlined,
                color: AppColors.textSecondary, size: 48),
          ),
        ),
      ),
    );
  }
}
