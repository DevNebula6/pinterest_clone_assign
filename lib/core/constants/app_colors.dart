import 'package:flutter/material.dart';

// all the colors used in the app, keeping them in one place makes it easy to update
class AppColors {
  AppColors._();

  // brand color (the pinterest red)
  static const Color pinterestRed = Color(0xFFE60023);

  // backgrounds
  static const Color white = Color(0xFFFFFFFF);
  static const Color lightGray = Color(0xFFF5F5F5);
  static const Color scaffoldBg = Color(0xFFFFFFFF);

  // text colors
  static const Color textPrimary = Color(0xFF111111);
  static const Color textSecondary = Color(0xFF767676);
  static const Color textTertiary = Color(0xFFB0B0B0);

  // misc ui stuff
  static const Color divider = Color(0xFFE0E0E0);
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);
  static const Color cardShadow = Color(0x1A000000);
  static const Color overlay = Color(0x66000000);
  static const Color iconInactive = Color(0xFF767676);
  static const Color iconActive = Color(0xFF111111);

  // button colors
  static const Color buttonGray = Color(0xFFEFEFEF);
  static const Color buttonGrayText = Color(0xFF111111);
  static const Color saveButtonRed = Color(0xFFE60023);

  // some random colors for board placeholders when theres no image
  static const List<Color> boardColors = [
    Color(0xFFE60023),
    Color(0xFF0076D3),
    Color(0xFF00A651),
    Color(0xFFFF8C00),
    Color(0xFF8B00FF),
  ];
}
