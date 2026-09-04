import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../../theme/app_colors.dart';
import 'package:intl/intl.dart' hide TextDirection;

extension StringExtensions on String {
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  bool get isEmail {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(this);
  }
  
  bool get isNotBlank => trim().isNotEmpty;
}

extension BuildContextExtensions on BuildContext {
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  
  bool get isRtl => Directionality.of(this) == TextDirection.rtl;

  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.error : colors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

extension DateTimeExtensions on DateTime {
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.inDays > 365) return '${(difference.inDays / 365).floor()} years ago';
    if (difference.inDays > 30) return '${(difference.inDays / 30).floor()} months ago';
    if (difference.inDays > 0) return '${difference.inDays} days ago';
    if (difference.inHours > 0) return '${difference.inHours} hours ago';
    if (difference.inMinutes > 0) return '${difference.inMinutes} minutes ago';
    return 'Just now';
  }

  String get formatted => DateFormat('yyyy-MM-dd').format(this);
}

extension MasteryTier on double {
  String get masteryTier {
    if (this >= AppConstants.masteryGood) return 'Mastered';
    if (this >= AppConstants.masteryDeveloping) return 'Good';
    if (this >= AppConstants.masteryNeedsPractice) return 'Developing';
    return 'Needs Practice';
  }

  Color get masteryColor {
    if (this >= AppConstants.masteryGood) return AppColors.masteryMastered;
    if (this >= AppConstants.masteryDeveloping) return AppColors.masteryGood;
    if (this >= AppConstants.masteryNeedsPractice) return AppColors.masteryDeveloping;
    return AppColors.masteryNeedsPractice;
  }
}
