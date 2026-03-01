class RoutePaths {
  RoutePaths._();

  static const String splash = '/splash';
  static const String login = '/login';
  static const String loginPassword = '/login/password';
  static const String signup = '/signup';
  static const String onboarding = '/onboarding';
  static const String home = '/';
  static const String search = '/search';
  static const String notifications = '/notifications';
  static const String profile = '/profile';

  // Nested under home branch
  static const String pinDetail = 'pin/:id';
  // Nested under search branch
  static const String searchPinDetail = 'pin/:id';
  // Nested under profile branch
  static const String boardDetail = 'board/:id';
  static const String settings = 'settings';
  static const String editProfile = 'edit';
}
