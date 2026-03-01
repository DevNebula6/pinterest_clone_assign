import 'dart:math';

import 'package:flutter/material.dart';

// draws the google G logo using custompainer, needed for the SSO button
class GoogleLogo extends StatelessWidget {
  const GoogleLogo({super.key, this.size = 20});

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _GoogleLogoPainter()),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  static const _blue = Color(0xFF4285F4);
  static const _red = Color(0xFFEA4335);
  static const _yellow = Color(0xFFFBBC05);
  static const _green = Color(0xFF34A853);

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final sw = s * 0.17;
    final center = Offset(s / 2, s / 2);
    final r = (s - sw) / 2;
    final oval = Rect.fromCircle(center: center, radius: r);

    final p = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = sw
      ..strokeCap = StrokeCap.butt;

    // blue arc on the right
    p.color = _blue;
    canvas.drawArc(oval, -pi / 6, pi / 2 + pi / 6, false, p);

    // green arc on the bottom
    p.color = _green;
    canvas.drawArc(oval, pi / 2, pi / 2, false, p);

    // yellow arc on the left
    p.color = _yellow;
    canvas.drawArc(oval, pi, pi / 2, false, p);

    // red arc on the top
    p.color = _red;
    canvas.drawArc(oval, 3 * pi / 2, pi / 3, false, p);

    // the little horizontal bar that makes it a G not an O
    p
      ..style = PaintingStyle.fill
      ..color = _blue;
    canvas.drawRect(
      Rect.fromLTWH(s * 0.48, center.dy - sw / 2, s * 0.38, sw),
      p,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
