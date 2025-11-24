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
    return _repo.signInWithEmailPassword(
      email: email,
      password: password,
    );
  }

  Future<(AuthUser?, AuthFailure?)> signUp({
    required String email,
    required String password,
    String? displayName,
  }) {
    return _repo.signUpWithEmailPassword(
      email: email,
      password: password,
      displayName: displayName,
    );
  }

  Future<AuthUser?> getCurrentUser() {
    return _repo.getCurrentUser();
  }

  Future<void> logout() {
    return _repo.signOut();
  }

  Future<void> resetPassword(String email) {
    return _repo.sendPasswordResetEmail(email);
  }
}

