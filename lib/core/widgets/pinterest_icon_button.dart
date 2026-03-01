import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';

class PinterestIconButton extends StatefulWidget {
  const PinterestIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = AppDimensions.iconMedium,
    this.backgroundColor,
    this.iconColor = AppColors.textPrimary,
    this.padding = AppDimensions.paddingSmall,
    this.semanticsLabel,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final double size;
  final Color? backgroundColor;
  final Color iconColor;
  final double padding;
  final String? semanticsLabel;

  @override
  State<PinterestIconButton> createState() => _PinterestIconButtonState();
}

class _PinterestIconButtonState extends State<PinterestIconButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
      reverseDuration: const Duration(milliseconds: 150),
      lowerBound: 0.85,
      upperBound: 1.0,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) => _controller.reverse();
  void _onTapUp(TapUpDetails _) => _controller.forward();
  void _onTapCancel() => _controller.forward();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.semanticsLabel,
      button: true,
      child: GestureDetector(
        onTapDown: widget.onPressed == null ? null : _onTapDown,
        onTapUp: widget.onPressed == null ? null : _onTapUp,
        onTapCancel: widget.onPressed == null ? null : _onTapCancel,
        onTap: widget.onPressed,
        child: ScaleTransition(
          scale: CurvedAnimation(
            parent: _controller,
            curve: Curves.easeInOut,
          ),
          child: Container(
            padding: EdgeInsets.all(widget.padding),
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              widget.icon,
              size: widget.size,
              color: widget.iconColor,
            ),
          ),
        ),
      ),
    );
  }
}
