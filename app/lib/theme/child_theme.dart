import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_radius.dart';

class ChildTheme {
  ChildTheme._();

  static ThemeData getTheme(ThemeData baseTheme) {
    return baseTheme.copyWith(
      colorScheme: baseTheme.colorScheme.copyWith(
        primary: AppColors.childPrimary,
        secondary: AppColors.secondary,
        tertiary: AppColors.childAccent,
        surface: AppColors.childSurface,
      ),
      scaffoldBackgroundColor: AppColors.childSurface,
      
      // Card Theme for Child
      cardTheme: baseTheme.cardTheme.copyWith(
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.childCard),
        elevation: 4,
        shadowColor: AppColors.childPrimary.withValues(alpha: 0.2),
      ),
      
      // Button Theme for Child - bigger touch targets, rounder
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondary,
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: AppColors.secondary.withValues(alpha: 0.4),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.childButton),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
      ),
      
      // Additional customizations for child UI...
    );
  }
}
