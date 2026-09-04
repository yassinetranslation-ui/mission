import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final FlutterSecureStorage _storage;

  const SecureStorage(this._storage);

  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _onboardingKey = 'onboarding_complete';

  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  Future<void> setOnboardingComplete(bool value) async {
    await _storage.write(key: _onboardingKey, value: value ? 'true' : 'false');
  }

  Future<bool> isOnboardingComplete() async {
    return (await _storage.read(key: _onboardingKey)) == 'true';
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
