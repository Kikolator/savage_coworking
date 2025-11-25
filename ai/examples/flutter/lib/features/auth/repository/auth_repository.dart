// lib/features/auth/repository/auth_repository.dart
/**
import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../models/auth_user.dart';
import '../models/auth_failure.dart';

class AuthRepository {
  final fb.FirebaseAuth _firebaseAuth;

  AuthRepository(this._firebaseAuth);

  Future<AuthUser?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;
    return AuthUser(
      id: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
    );
  }

  Future<(AuthUser?, AuthFailure?)> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final cred = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = cred.user;
      if (user == null) {
        return (null, const AuthFailure.unexpected('No user returned'));
      }
      return (
        AuthUser(
          id: user.uid,
          email: user.email ?? '',
          displayName: user.displayName,
        ),
        null,
      );
    } on fb.FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password' || e.code == 'user-not-found') {
        return (null, const AuthFailure.invalidCredentials());
      }
      return (null, AuthFailure.unexpected(e.message));
    } catch (e) {
      return (null, const AuthFailure.network());
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
*/
