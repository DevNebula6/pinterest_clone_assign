import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_typography.dart';

enum PinterestButtonVariant { primary, secondary, outline }

class PinterestButton extends StatefulWidget {
  const PinterestButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = PinterestButtonVariant.primary,
    this.isLoading = false,
    this.isFullWidth = true,
    this.height = AppDimensions.buttonHeight,
    this.leadingIcon,
  });

  const PinterestButton.primary({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.height = AppDimensions.buttonHeight,
    this.leadingIcon,
  }) : variant = PinterestButtonVariant.primary;

  const PinterestButton.secondary({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.height = AppDimensions.buttonHeight,
    this.leadingIcon,
  }) : variant = PinterestButtonVariant.secondary;

  const PinterestButton.outline({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.height = AppDimensions.buttonHeight,
    this.leadingIcon,
  }) : variant = PinterestButtonVariant.outline;

  final String label;
  final VoidCallback? onPressed;
  final PinterestButtonVariant variant;
  final bool isLoading;
  final bool isFullWidth;
  final double height;
  final Widget? leadingIcon;

  @override
  State<PinterestButton> createState() => _PinterestButtonState();
}

class _PinterestButtonState extends State<PinterestButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
      reverseDuration: const Duration(milliseconds: 150),
      lowerBound: 0.94,
      upperBound: 1.0,
      value: 1.0,
    );
    _scaleAnim =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) => _controller.reverse();
  void _onTapUp(TapUpDetails _) => _controller.forward();
  void _onTapCancel() => _controller.forward();

  void _onTap() {
    if (widget.onPressed == null || widget.isLoading) return;
    HapticFeedback.lightImpact();
    widget.onPressed!();
  }

  Color get _bgColor {
    switch (widget.variant) {
      case PinterestButtonVariant.primary:
        return AppColors.pinterestRed;
      case PinterestButtonVariant.secondary:
        return AppColors.buttonGray;
      case PinterestButtonVariant.outline:
        return Colors.transparent;
    }
  }

  Color get _fgColor {
    switch (widget.variant) {
      case PinterestButtonVariant.primary:
        return AppColors.white;
      case PinterestButtonVariant.secondary:
        return AppColors.buttonGrayText;
      case PinterestButtonVariant.outline:
        return AppColors.textPrimary;
    }
  }

  Border? get _border {
    if (widget.variant == PinterestButtonVariant.outline) {
      return Border.all(color: AppColors.divider, width: 1.5);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onPressed == null || widget.isLoading;

    return GestureDetector(
      onTapDown: isDisabled ? null : _onTapDown,
      onTapUp: isDisabled ? null : _onTapUp,
      onTapCancel: isDisabled ? null : _onTapCancel,
      onTap: isDisabled ? null : _onTap,
      child: ScaleTransition(
        scale: _scaleAnim,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 150),
          opacity: isDisabled ? 0.5 : 1.0,
          child: Container(
            width: widget.isFullWidth ? double.infinity : null,
            height: widget.height,
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingXLarge,
            ),
            decoration: BoxDecoration(
              color: _bgColor,
              borderRadius:
                  BorderRadius.circular(AppDimensions.radiusRound),
              border: _border,
            ),
            child: Center(
              child: widget.isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(_fgColor),
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.leadingIcon != null) ...[
                          widget.leadingIcon!,
                          const SizedBox(width: AppDimensions.paddingSmall),
                        ],
                        Text(
                          widget.label,
                          style: AppTypography.labelLarge.copyWith(
                            color: _fgColor,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
