import 'dart:io';
import '../core/constants/app_constants.dart';

enum Environment { dev, staging, prod }

class AppConfig {
  final Environment environment;
  final String apiBaseUrl;
  final bool isDemoMode;

  const AppConfig({
    required this.environment,
    required this.apiBaseUrl,
    this.isDemoMode = false,
  });

  // Default configuration for development
  static AppConfig get dev {
    String baseUrl = AppConstants.defaultApiBaseUrl;
    try {
      if (Platform.isAndroid) {
        baseUrl = 'http://10.0.2.2:8000/api/v1';
      }
    } catch (_) {
      // Fallback for Web
    }
    return AppConfig(
      environment: Environment.dev,
      apiBaseUrl: baseUrl,
      isDemoMode: true,
    );
  }

  static AppConfig get staging => const AppConfig(
    environment: Environment.staging,
    apiBaseUrl: 'https://staging-api.misson.com/api/v1',
  );

  static AppConfig get prod => const AppConfig(
    environment: Environment.prod,
    apiBaseUrl: 'https://game.motrjim.com/api/v1',
  );
  
  // Return active config
  static AppConfig get active => prod; // Points to live server
}
