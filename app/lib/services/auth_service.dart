import 'package:dio/dio.dart';
import '../models/user.dart';

class AuthResponse {
  final User user;
  final String accessToken;
  final String refreshToken;

  const AuthResponse({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      accessToken: (json['access_token'] ?? json['accessToken']) as String,
      refreshToken: (json['refresh_token'] ?? json['refreshToken']) as String,
    );
  }
}

class AuthService {
  final Dio _dio;

  AuthService(this._dio);

  Future<User> register(String email, String password, String name) async {
    final response = await _dio.post('/auth/register', data: {
      'email': email,
      'password': password,
      'name': name,
    });
    if (response.data is Map && response.data['user'] != null) {
      return User.fromJson(response.data['user'] as Map<String, dynamic>);
    }
    return User.fromJson(response.data as Map<String, dynamic>);
  }

  Future<AuthResponse> login(String email, String password) async {
    final response = await _dio.post('/auth/login', data: {
      'email': email,
      'password': password,
    });
    return AuthResponse.fromJson(response.data as Map<String, dynamic>);
  }

  Future<AuthResponse> refreshToken(String refreshToken) async {
    final response = await _dio.post('/auth/refresh', data: {
      'refresh_token': refreshToken,
    });
    return AuthResponse.fromJson(response.data as Map<String, dynamic>);
  }

  Future<User> getCurrentUser() async {
    final response = await _dio.get('/auth/me');
    return User.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> logout() async {
    try {
      await _dio.post('/auth/logout');
    } catch (_) {
      // Stateless JWT logout is handled on client-side
    }
  }
}
