import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_typography.dart';

// all the theme stuff - tried to match the real pinterest app as closely as i could
class AppTheme {
  AppTheme._();

  // main light theme
  static ThemeData get light {
    const colorScheme = ColorScheme.light(
      primary: AppColors.pinterestRed,
      onPrimary: AppColors.white,
      secondary: AppColors.textPrimary,
      onSecondary: AppColors.white,
      surface: AppColors.white,
      onSurface: AppColors.textPrimary,
      error: Color(0xFFB00020),
      onError: AppColors.white,
      outline: AppColors.divider,
      surfaceContainerHighest: AppColors.lightGray,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.scaffoldBg,

      // -------------------------------------------------------------------
      // Typography
      // -------------------------------------------------------------------
      textTheme: const TextTheme(
        displayLarge: AppTypography.h1,
        displayMedium: AppTypography.h2,
        displaySmall: AppTypography.h3,
        bodyLarge: AppTypography.bodyLarge,
        bodyMedium: AppTypography.bodyMedium,
        bodySmall: AppTypography.bodySmall,
        labelLarge: AppTypography.labelLarge,
        labelMedium: AppTypography.labelMedium,
        labelSmall: AppTypography.labelSmall,
        titleLarge: AppTypography.h3,
        titleMedium: AppTypography.labelLarge,
        titleSmall: AppTypography.labelMedium,
      ),

      // -------------------------------------------------------------------
      // AppBar — transparent, no elevation, dark icons
      // -------------------------------------------------------------------
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: AppColors.iconActive),
        titleTextStyle: AppTypography.h3,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),

      // -------------------------------------------------------------------
      // Bottom Navigation Bar
      // -------------------------------------------------------------------
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        elevation: 0,
        selectedItemColor: AppColors.iconActive,
        unselectedItemColor: AppColors.iconInactive,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
      ),

      // -------------------------------------------------------------------
      // Card — rounded, subtle shadow
      // -------------------------------------------------------------------
      cardTheme: CardThemeData(
        color: AppColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.pinCardBorderRadius),
        ),
        clipBehavior: Clip.antiAlias,
      ),

      // -------------------------------------------------------------------
      // Input Decoration (search bar)
      // -------------------------------------------------------------------
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.lightGray,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingLarge,
          vertical: AppDimensions.paddingMedium,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
          borderSide: const BorderSide(
            color: AppColors.pinterestRed,
            width: 2,
          ),
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textTertiary,
        ),
      ),

      // -------------------------------------------------------------------
      // ElevatedButton (primary = red, matches Pinterest "Save" button)
      // -------------------------------------------------------------------
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.pinterestRed,
          foregroundColor: AppColors.white,
          elevation: 0,
          minimumSize: const Size(64, AppDimensions.buttonHeight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
          ),
          textStyle: AppTypography.buttonLarge,
        ),
      ),

      // -------------------------------------------------------------------
      // OutlinedButton
      // -------------------------------------------------------------------
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          minimumSize: const Size(64, AppDimensions.buttonHeight),
          side: const BorderSide(color: AppColors.divider),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
          ),
          textStyle: AppTypography.buttonLarge.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
      ),

      // -------------------------------------------------------------------
      // TextButton
      // -------------------------------------------------------------------
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.pinterestRed,
          textStyle: AppTypography.labelMedium.copyWith(
            color: AppColors.pinterestRed,
          ),
        ),
      ),

      // -------------------------------------------------------------------
      // Icons
      // -------------------------------------------------------------------
      iconTheme: const IconThemeData(
        color: AppColors.iconActive,
        size: AppDimensions.iconMedium,
      ),

      // -------------------------------------------------------------------
      // Divider
      // -------------------------------------------------------------------
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),

      // -------------------------------------------------------------------
      // Chip (filter pills)
      // -------------------------------------------------------------------
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.white,
        selectedColor: AppColors.textPrimary,
        labelStyle: AppTypography.labelSmall,
        side: const BorderSide(color: AppColors.divider),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusRound),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingMedium,
          vertical: AppDimensions.paddingXSmall,
        ),
      ),

      // -------------------------------------------------------------------
      // Page transitions
      // -------------------------------------------------------------------
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
    );
  }
}
