import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../config/app_config.dart';
import 'api_interceptors.dart';
import '../storage/secure_storage.dart';

class ApiClient {
  late final Dio _dio;
  final SecureStorage _secureStorage;
  final AppConfig _appConfig;
  
  ApiClient(this._secureStorage, this._appConfig) {
    _dio = Dio(BaseOptions(
      baseUrl: _appConfig.apiBaseUrl,
      // Render's free tier can take ~50s to wake from spin-down on the first
      // request, so keep timeouts generous to avoid a cold-start failure.
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _dio.interceptors.addAll([
      AuthInterceptor(_secureStorage),
      ErrorInterceptor(),
      if (_appConfig.environment == Environment.dev) LoggingInterceptor(),
    ]);
  }

  Dio get dio => _dio;
  
  Future<bool> hasConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return !connectivityResult.contains(ConnectivityResult.none);
  }
}
