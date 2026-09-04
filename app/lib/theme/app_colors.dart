import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary: Deep purple - represents AI + Gaming
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryLight = Color(0xFF8A84FF);
  static const Color primaryDark = Color(0xFF4A41D4);
  
  // Secondary: Vibrant orange - energy, fun
  static const Color secondary = Color(0xFFFF6B35);
  static const Color secondaryLight = Color(0xFFFF8C61);
  static const Color secondaryDark = Color(0xFFD64A12);

  // Tertiary: Teal - growth, education
  static const Color tertiary = Color(0xFF00BFA6);
  static const Color tertiaryLight = Color(0xFF33CCB8);
  static const Color tertiaryDark = Color(0xFF008F7C);

  // Semantic Colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Neutral Palette (Grayscale)
  static const Color neutral50 = Color(0xFFFAFAFA);
  static const Color neutral100 = Color(0xFFF5F5F5);
  static const Color neutral200 = Color(0xFFEEEEEE);
  static const Color neutral300 = Color(0xFFE0E0E0);
  static const Color neutral400 = Color(0xFFBDBDBD);
  static const Color neutral500 = Color(0xFF9E9E9E);
  static const Color neutral600 = Color(0xFF757575);
  static const Color neutral700 = Color(0xFF616161);
  static const Color neutral800 = Color(0xFF424242);
  static const Color neutral900 = Color(0xFF212121);

  // Surface Colors
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E1E2C);
  static const Color backgroundLight = Color(0xFFF8F9FE);
  static const Color backgroundDark = Color(0xFF12121D);

  // Parent Mode specific (Subdued, trustworthy blues)
  static const Color parentPrimary = Color(0xFF2E5BFF);
  static const Color parentSurface = Color(0xFFF2F5FF);
  
  // Child Mode specific (Vibrant, energetic)
  static const Color childPrimary = Color(0xFF00C9A7);
  static const Color childSurface = Color(0xFFE5F9F5);
  static const Color childAccent = Color(0xFFFFC75F);

  // Mastery Colors
  static const Color masteryNeedsPractice = Color(0xFFF44336); // Red
  static const Color masteryDeveloping = Color(0xFFFFC107); // Yellow
  static const Color masteryGood = Color(0xFF8BC34A); // Light Green
  static const Color masteryMastered = Color(0xFF4CAF50); // Green

  // Gamification Colors
  static const Color xpGold = Color(0xFFFFD700);
  static const Color streakFire = Color(0xFFFF5722);
  static const Color gemBlue = Color(0xFF00BCD4);
}
