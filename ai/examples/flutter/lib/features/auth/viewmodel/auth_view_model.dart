// lib/features/auth/viewmodel/auth_view_model.dart
/**
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/auth_user.dart';
import '../models/auth_failure.dart';
import '../service/auth_service.dart';

class AuthState {
  final bool isLoading;
  final AuthUser? user;
  final AuthFailure? failure;

  const AuthState({this.isLoading = false, this.user, this.failure});

  AuthState copyWith({bool? isLoading, AuthUser? user, AuthFailure? failure}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      failure: failure,
    );
  }
}

class AuthViewModel extends StateNotifier<AuthState> {
  final AuthService _service;

  AuthViewModel(this._service) : super(const AuthState());

  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, failure: null);
    final (user, failure) = await _service.login(
      email: email,
      password: password,
    );
    state = state.copyWith(isLoading: false, user: user, failure: failure);
  }

  Future<void> loadCurrentUser() async {
    state = state.copyWith(isLoading: true);
    final user = await _service.getCurrentUser();
    state = state.copyWith(isLoading: false, user: user);
  }

  Future<void> logout() async {
    await _service.logout();
    state = const AuthState();
  }
}

// Providers

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  // TODO: inject FirebaseAuth instance from a higher-level provider
  throw UnimplementedError('Provide FirebaseAuth instance here');
});

final authServiceProvider = Provider<AuthService>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthService(repo);
});

final authViewModelProvider = StateNotifierProvider<AuthViewModel, AuthState>((
  ref,
) {
  final service = ref.watch(authServiceProvider);
  return AuthViewModel(service);
});
*/
