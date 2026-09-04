class AppConstants {
  AppConstants._();

  static const String appName = 'Misson';
  static const String defaultApiBaseUrl = 'http://127.0.0.1:8000/api/v1'; // Can be overridden by AppConfig
  
  // File Upload Limits
  static const int maxFileSizeMb = 10;
  static const int maxFileSizeBytes = maxFileSizeMb * 1024 * 1024;
  static const List<String> supportedExtensions = ['pdf', 'png', 'jpg', 'jpeg', 'docx', 'txt'];
  
  // Gamification
  static const int xpPerCorrectAnswer = 10;
  static const int xpForBoss = 50;
  static const int xpForPerfectScore = 100;
  static const int xpPerStreakDay = 5;

  // Mastery thresholds (0.0 to 1.0)
  static const double masteryNeedsPractice = 0.4;
  static const double masteryDeveloping = 0.7;
  static const double masteryGood = 0.9;
  static const double masteryMastered = 1.0;
}
