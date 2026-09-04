import '../services/auth_service.dart';
import '../models/user.dart';

import '../core/storage/secure_storage.dart';

class AuthRepository {
  final AuthService _authService;
  final SecureStorage _secureStorage;
  
  User? _currentUser;

  AuthRepository(this._authService, this._secureStorage);

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  Future<void> init() async {
    final token = await _secureStorage.getToken();
    if (token != null) {
      try {
        _currentUser = await _authService.getCurrentUser();
      } catch (e) {
        // Token might be expired
        _currentUser = null;
      }
    }
  }

  Future<User> login(String email, String password) async {
    final response = await _authService.login(email, password);
    await _secureStorage.saveToken(response.accessToken);
    await _secureStorage.saveRefreshToken(response.refreshToken);
    _currentUser = response.user;
    return response.user;
  }

  Future<User> register(String email, String password, String name) async {
    final user = await _authService.register(email, password, name);
    // Usually login happens automatically or requires manual step
    return user;
  }

  Future<void> logout() async {
    try {
      await _authService.logout();
    } finally {
      await _secureStorage.clearAll();
      _currentUser = null;
    }
  }

  Future<bool> isOnboardingComplete() => _secureStorage.isOnboardingComplete();

  Future<void> markOnboardingComplete() => _secureStorage.setOnboardingComplete(true);
}
