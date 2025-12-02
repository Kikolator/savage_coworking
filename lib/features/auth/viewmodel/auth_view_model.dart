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

  Future<void> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    state = state.copyWith(isLoading: true, failure: null);
    final (user, failure) = await _service.signUp(
      email: email,
      password: password,
      displayName: displayName,
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

  Future<void> resetPassword(String email) async {
    state = state.copyWith(isLoading: true, failure: null);
    try {
      await _service.resetPassword(email);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        failure: AuthFailure.unexpected(e.toString()),
      );
    }
  }

  void clearFailure() {
    state = state.copyWith(failure: null);
  }

  void syncUser(AuthUser? user) {
    // Only update if user actually changed to avoid unnecessary rebuilds
    if (state.user?.id != user?.id) {
      state = state.copyWith(user: user);
    }
  }
}
