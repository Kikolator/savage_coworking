// lib/features/auth/service/auth_service.dart
/**
import '../models/auth_user.dart';
import '../models/auth_failure.dart';
import '../repository/auth_repository.dart';

class AuthService {
  final AuthRepository _repo;

  AuthService(this._repo);

  Future<(AuthUser?, AuthFailure?)> login({
    required String email,
    required String password,
  }) {
    // place to add business rules later (logging, tracking, etc.)
    return _repo.signInWithEmailPassword(email: email, password: password);
  }

  Future<AuthUser?> getCurrentUser() {
    return _repo.getCurrentUser();
  }

  Future<void> logout() {
    return _repo.signOut();
  }
}
*/
