import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../config/dependency_injection.dart';
import '../../../repositories/auth_repository.dart';
import '../../../services/auth_service.dart';

// Provides the AuthRepository dependency
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  return AuthRepository(
    AuthService(apiClient.dio),
    secureStorage,
  );
});

class AuthState {
  final bool isAuthenticated;
  final bool hasCompletedOnboarding;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.isAuthenticated = false,
    this.hasCompletedOnboarding = false,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? hasCompletedOnboarding,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      hasCompletedOnboarding: hasCompletedOnboarding ?? this.hasCompletedOnboarding,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(const AuthState(isLoading: true)) {
    _init();
  }

  Future<void> _init() async {
    try {
      await _repository.init();
      state = state.copyWith(
        isAuthenticated: _repository.isAuthenticated,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.login(email, password);
      state = state.copyWith(isAuthenticated: true, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  Future<void> register(String email, String password, String name) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.register(email, password, name);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      rethrow;
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _repository.logout();
      state = state.copyWith(isAuthenticated: false, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void completeOnboarding() {
    state = state.copyWith(hasCompletedOnboarding: true);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});
