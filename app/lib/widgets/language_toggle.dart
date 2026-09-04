import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// A compact pill that switches between Arabic and English.
/// Shows the language the user would switch *to*.
class LanguageToggle extends StatelessWidget {
  final bool isArabic;
  final VoidCallback onToggle;

  const LanguageToggle({
    required this.isArabic,
    required this.onToggle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // If currently Arabic, offer English, and vice-versa.
    final targetLabel = isArabic ? 'English' : 'العربية';

    return Material(
      color: AppColors.primary.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: onToggle,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.language, size: 18, color: AppColors.primary),
              const SizedBox(width: 6),
              Text(
                targetLabel,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
