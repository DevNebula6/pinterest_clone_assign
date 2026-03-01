import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  // theme
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;

  // media query
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;
  EdgeInsets get padding => MediaQuery.paddingOf(this);
  double get bottomInset => MediaQuery.viewInsetsOf(this).bottom;
  bool get isKeyboardVisible => MediaQuery.viewInsetsOf(this).bottom > 0;
  double get devicePixelRatio => MediaQuery.devicePixelRatioOf(this);
  bool get isTablet => MediaQuery.sizeOf(this).width >= 600;

  // navigation helpers
  void pop<T>([T? result]) => Navigator.of(this).pop(result);
  void hideKeyboard() => FocusScope.of(this).unfocus();
}
