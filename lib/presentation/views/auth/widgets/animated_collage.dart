import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

// the animated collage shown on the login screen - images slide in and then gently pulse
class AnimatedCollage extends StatefulWidget {
  const AnimatedCollage({super.key});

  @override
  State<AnimatedCollage> createState() => _AnimatedCollageState();
}

class _AnimatedCollageState extends State<AnimatedCollage>
    with TickerProviderStateMixin {
  late final AnimationController _slideController;
  late final AnimationController _pulseController;

  // each image has a position (as fraction of container size) and where it slides in from
  static const _images = [
    // top left corner - interior photo
    _CollageImage(
      url:
          'https://images.pexels.com/photos/1571460/pexels-photo-1571460.jpeg?auto=compress&cs=tinysrgb&w=400',
      leftFrac: -0.02,
      topFrac: -0.05,
      widthFrac: 0.50,
      heightFrac: 0.52,
      slideFrom: Offset(-1.5, -0.5),
    ),
    // center - fashion photo, this one is taller than the others
    _CollageImage(
      url:
          'https://images.pexels.com/photos/2043590/pexels-photo-2043590.jpeg?auto=compress&cs=tinysrgb&w=400',
      leftFrac: 0.25,
      topFrac: 0.05,
      widthFrac: 0.50,
      heightFrac: 0.78,
      slideFrom: Offset(0, -1.5),
    ),
    // upper right - beauty/makeup photo
    _CollageImage(
      url:
          'https://images.pexels.com/photos/3373716/pexels-photo-3373716.jpeg?auto=compress&cs=tinysrgb&w=400',
      leftFrac: 0.62,
      topFrac: 0.15,
      widthFrac: 0.42,
      heightFrac: 0.42,
      slideFrom: Offset(1.5, -0.3),
    ),
    // bottom left - food photo
    _CollageImage(
      url:
          'https://images.pexels.com/photos/376464/pexels-photo-376464.jpeg?auto=compress&cs=tinysrgb&w=400',
      leftFrac: -0.05,
      topFrac: 0.50,
      widthFrac: 0.46,
      heightFrac: 0.55,
      slideFrom: Offset(-1.5, 0.5),
    ),
    // bottom right - home decor photo
    _CollageImage(
      url:
          'https://images.pexels.com/photos/1099816/pexels-photo-1099816.jpeg?auto=compress&cs=tinysrgb&w=400',
      leftFrac: 0.70,
      topFrac: 0.55,
      widthFrac: 0.36,
      heightFrac: 0.42,
      slideFrom: Offset(1.5, 0.5),
    ),
  ];

  @override
  void initState() {
    super.initState();

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..forward();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _slideController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;

        return ClipRect(
          child: Stack(
            children: [
              // Collage images
              ...List.generate(_images.length, (i) {
                final img = _images[i];

                // Staggered slide-in curve per image
                final slideAnim = Tween<Offset>(
                  begin: img.slideFrom,
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: _slideController,
                  curve: Interval(
                    i * 0.08,
                    0.5 + i * 0.10,
                    curve: Curves.easeOutCubic,
                  ),
                ));

                final phaseOffset = i * 0.2;

                return AnimatedBuilder(
                  animation:
                      Listenable.merge([_slideController, _pulseController]),
                  builder: (context, child) {
                    final slide = slideAnim.value;

                    // Gentle pulsate — each image breathes at its own phase
                    final pulse =
                        (_pulseController.value + phaseOffset) % 1.0;
                    final scale = 1.0 + 0.025 * sin(pulse * pi);

                    return Positioned(
                      left: (img.leftFrac + slide.dx) * w,
                      top: (img.topFrac + slide.dy) * h,
                      width: img.widthFrac * w,
                      height: img.heightFrac * h,
                      child: Transform.scale(
                        scale: scale,
                        child: child,
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CachedNetworkImage(
                      imageUrl: img.url,
                      fit: BoxFit.cover,
                      placeholder: (_, __) =>
                          Container(color: const Color(0xFFF0F0F0)),
                      errorWidget: (_, __, ___) =>
                          Container(color: const Color(0xFFF0F0F0)),
                    ),
                  ),
                );
              }),

              // Fade-to-white gradient at bottom
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: h * 0.30,
                child: const IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0x00FFFFFF),
                          Color(0xFFFFFFFF),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CollageImage {
  const _CollageImage({
    required this.url,
    required this.leftFrac,
    required this.topFrac,
    required this.widthFrac,
    required this.heightFrac,
    required this.slideFrom,
  });

  final String url;
  final double leftFrac;
  final double topFrac;
  final double widthFrac;
  final double heightFrac;
  final Offset slideFrom;
}
