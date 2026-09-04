import 'package:flutter/material.dart';

/// Misson design-system palette — a bright, playful identity.
///
/// Parent mode leans on a friendly indigo/blue (calm, trustworthy) while the
/// child mode is warm and energetic (coral + sunny yellow). Field names are
/// kept stable so existing screens keep working; only the values changed.
class AppColors {
  AppColors._();

  // Primary: friendly indigo-blue — AI + focus
  static const Color primary = Color(0xFF4C6EF5);
  static const Color primaryLight = Color(0xFF7C90F8);
  static const Color primaryDark = Color(0xFF3450D6);

  // Secondary: warm coral — energy, fun
  static const Color secondary = Color(0xFFFF7A59);
  static const Color secondaryLight = Color(0xFFFF9E85);
  static const Color secondaryDark = Color(0xFFE85A38);

  // Tertiary: fresh mint — growth, education
  static const Color tertiary = Color(0xFF2BC48A);
  static const Color tertiaryLight = Color(0xFF57D6A6);
  static const Color tertiaryDark = Color(0xFF1EA372);

  // Semantic Colors
  static const Color success = Color(0xFF37B24D);
  static const Color warning = Color(0xFFFFB020);
  static const Color error = Color(0xFFF03E3E);
  static const Color info = Color(0xFF4DABF7);

  // Neutral Palette (Grayscale, slightly warm)
  static const Color neutral50 = Color(0xFFFAFAFC);
  static const Color neutral100 = Color(0xFFF3F4F8);
  static const Color neutral200 = Color(0xFFE9EBF1);
  static const Color neutral300 = Color(0xFFDCDFE8);
  static const Color neutral400 = Color(0xFFB8BDCC);
  static const Color neutral500 = Color(0xFF929AAD);
  static const Color neutral600 = Color(0xFF6B7385);
  static const Color neutral700 = Color(0xFF4D5566);
  static const Color neutral800 = Color(0xFF333A49);
  static const Color neutral900 = Color(0xFF1C2130);

  // Surface Colors
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E2231);
  static const Color backgroundLight = Color(0xFFF6F7FB);
  static const Color backgroundDark = Color(0xFF13161F);

  // Parent Mode specific (calm, trustworthy indigo)
  static const Color parentPrimary = Color(0xFF4C6EF5);
  static const Color parentSurface = Color(0xFFEEF1FE);

  // Child Mode specific (vibrant, energetic)
  static const Color childPrimary = Color(0xFFFF8A3D);
  static const Color childPrimaryDark = Color(0xFFF06D1A);
  static const Color childSurface = Color(0xFFFFF3E8);
  static const Color childAccent = Color(0xFFFFC93C);

  // Mastery Colors
  static const Color masteryNeedsPractice = Color(0xFFF03E3E); // Red
  static const Color masteryDeveloping = Color(0xFFFFB020); // Amber
  static const Color masteryGood = Color(0xFF82C91E); // Light Green
  static const Color masteryMastered = Color(0xFF37B24D); // Green

  // Gamification Colors
  static const Color xpGold = Color(0xFFFFC93C);
  static const Color streakFire = Color(0xFFFF6B35);
  static const Color gemBlue = Color(0xFF3BC9DB);

  // Common gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF5B7BFF), Color(0xFF4C6EF5), Color(0xFF6C5CE7)],
  );

  static const LinearGradient childGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFA94D), Color(0xFFFF8A3D), Color(0xFFFF7A59)],
  );

  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF37B24D), Color(0xFF2BC48A)],
  );
}
