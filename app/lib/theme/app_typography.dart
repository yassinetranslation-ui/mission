import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography for Misson.
///
/// Arabic uses **Cairo** (clean, highly legible RTL) and Latin uses **Nunito**
/// (rounded and friendly) to match the playful identity. Game numerals use
/// **Fredoka** for a chunky, arcade feel.
class AppTypography {
  AppTypography._();

  static String fontFor({required bool isArabic}) {
    return isArabic ? GoogleFonts.cairo().fontFamily! : GoogleFonts.nunito().fontFamily!;
  }

  static TextTheme getTextTheme(BuildContext context, {bool isArabic = false}) {
    final baseTheme = Theme.of(context).textTheme;
    final fontFamily = fontFor(isArabic: isArabic);

    return baseTheme.copyWith(
      displayLarge: TextStyle(fontFamily: fontFamily, fontSize: 57, fontWeight: FontWeight.w800, letterSpacing: -0.25),
      displayMedium: TextStyle(fontFamily: fontFamily, fontSize: 45, fontWeight: FontWeight.w800, letterSpacing: 0),
      displaySmall: TextStyle(fontFamily: fontFamily, fontSize: 36, fontWeight: FontWeight.w800, letterSpacing: 0),
      headlineLarge: TextStyle(fontFamily: fontFamily, fontSize: 32, fontWeight: FontWeight.w800, letterSpacing: 0),
      headlineMedium: TextStyle(fontFamily: fontFamily, fontSize: 28, fontWeight: FontWeight.w700, letterSpacing: 0),
      headlineSmall: TextStyle(fontFamily: fontFamily, fontSize: 24, fontWeight: FontWeight.w700, letterSpacing: 0),
      titleLarge: TextStyle(fontFamily: fontFamily, fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: 0),
      titleMedium: TextStyle(fontFamily: fontFamily, fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.15),
      titleSmall: TextStyle(fontFamily: fontFamily, fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.1),
      bodyLarge: TextStyle(fontFamily: fontFamily, fontSize: 16, fontWeight: FontWeight.normal, letterSpacing: 0.2, height: 1.5),
      bodyMedium: TextStyle(fontFamily: fontFamily, fontSize: 14, fontWeight: FontWeight.normal, letterSpacing: 0.15, height: 1.5),
      bodySmall: TextStyle(fontFamily: fontFamily, fontSize: 12, fontWeight: FontWeight.normal, letterSpacing: 0.2, height: 1.4),
      labelLarge: TextStyle(fontFamily: fontFamily, fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 0.1),
      labelMedium: TextStyle(fontFamily: fontFamily, fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.4),
      labelSmall: TextStyle(fontFamily: fontFamily, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.4),
    );
  }

  // Game-specific TextStyles
  static TextStyle gameTitle(BuildContext context, {bool isArabic = false}) {
    final fontFamily = fontFor(isArabic: isArabic);
    return TextStyle(fontFamily: fontFamily, fontSize: 32, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 0.8);
  }

  static TextStyle gameQuestion(BuildContext context, {bool isArabic = false}) {
    final fontFamily = fontFor(isArabic: isArabic);
    return TextStyle(fontFamily: fontFamily, fontSize: 24, fontWeight: FontWeight.w700, height: 1.4);
  }

  static TextStyle gameAnswer(BuildContext context, {bool isArabic = false}) {
    final fontFamily = fontFor(isArabic: isArabic);
    return TextStyle(fontFamily: fontFamily, fontSize: 18, fontWeight: FontWeight.w600);
  }

  static TextStyle gameScore(BuildContext context) {
    return GoogleFonts.fredoka(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white);
  }

  static TextStyle gameXp(BuildContext context) {
    return GoogleFonts.fredoka(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFFFFC93C));
  }

  // Child-specific styles
  static TextStyle childGreeting(BuildContext context, {bool isArabic = false}) {
    final fontFamily = fontFor(isArabic: isArabic);
    return TextStyle(fontFamily: fontFamily, fontSize: 28, fontWeight: FontWeight.w800);
  }

  static TextStyle childMissionTitle(BuildContext context, {bool isArabic = false}) {
    final fontFamily = fontFor(isArabic: isArabic);
    return TextStyle(fontFamily: fontFamily, fontSize: 20, fontWeight: FontWeight.w700);
  }
}
