import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'app_config.dart';
import '../core/network/api_client.dart';
import '../core/storage/secure_storage.dart';
import '../core/storage/local_cache.dart';
import '../repositories/child_repository.dart';
import '../repositories/game_repository.dart';
import '../repositories/progress_repository.dart';
import '../services/child_service.dart';
import '../services/upload_service.dart';
import '../services/game_service.dart';
import '../services/progress_service.dart';

// App Config Provider
final appConfigProvider = Provider<AppConfig>((ref) {
  return AppConfig.active;
});

// Storage Providers
final flutterSecureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
});

final secureStorageProvider = Provider<SecureStorage>((ref) {
  return SecureStorage(ref.watch(flutterSecureStorageProvider));
});

final localCacheProvider = Provider<LocalCache>((ref) {
  return LocalCache();
});

// Network Provider
final apiClientProvider = Provider<ApiClient>((ref) {
  final config = ref.watch(appConfigProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  return ApiClient(secureStorage, config);
});

final dioProvider = Provider((ref) {
  return ref.watch(apiClientProvider).dio;
});

final childRepositoryProvider = Provider<ChildRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ChildRepository(ChildService(apiClient.dio));
});

final uploadServiceProvider = Provider<UploadService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return UploadService(apiClient.dio);
});

final gameServiceProvider = Provider<GameService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return GameService(apiClient.dio);
});

final gameRepositoryProvider = Provider<GameRepository>((ref) {
  final gameService = ref.watch(gameServiceProvider);
  final localCache = ref.watch(localCacheProvider);
  return GameRepository(gameService, localCache);
});

final progressServiceProvider = Provider<ProgressService>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ProgressService(apiClient.dio);
});

final progressRepositoryProvider = Provider<ProgressRepository>((ref) {
  final progressService = ref.watch(progressServiceProvider);
  return ProgressRepository(progressService);
});
