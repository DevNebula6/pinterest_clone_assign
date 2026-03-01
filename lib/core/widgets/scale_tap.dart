import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ScaleTap extends StatefulWidget {
  const ScaleTap({
    super.key,
    required this.child,
    required this.onPressed,
    this.scaleTo = 0.94,
    this.enableHaptic = true,
    this.duration = const Duration(milliseconds: 80),
    this.reverseDuration = const Duration(milliseconds: 160),
  });

  final Widget child;
  final VoidCallback? onPressed;
  final double scaleTo;
  final bool enableHaptic;
  final Duration duration;
  final Duration reverseDuration;

  @override
  State<ScaleTap> createState() => _ScaleTapState();
}

class _ScaleTapState extends State<ScaleTap>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      reverseDuration: widget.reverseDuration,
      lowerBound: widget.scaleTo,
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

  void _onTapDown(TapDownDetails _) {
    if (widget.onPressed == null) return;
    _controller.reverse();
  }

  void _onTapUp(TapUpDetails _) => _controller.forward();
  void _onTapCancel() => _controller.forward();

  Future<void> _onTap() async {
    if (widget.onPressed == null) return;
    if (widget.enableHaptic) {
      await HapticFeedback.lightImpact();
    }
    widget.onPressed!();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: _onTap,
      behavior: HitTestBehavior.opaque,
      child: ScaleTransition(
        scale: _scaleAnim,
        child: widget.child,
      ),
    );
  }
}
