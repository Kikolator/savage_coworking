import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../models/auth_user.dart';
import '../models/auth_failure.dart';

class AuthRepository {
  final fb.FirebaseAuth _firebaseAuth;

  AuthRepository(this._firebaseAuth);

  Stream<AuthUser?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((user) {
      if (user == null) return null;
      return AuthUser(
        id: user.uid,
        email: user.email ?? '',
        displayName: user.displayName,
        photoUrl: user.photoURL,
      );
    });
  }

  Future<AuthUser?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;
    return AuthUser(
      id: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      photoUrl: user.photoURL,
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
          photoUrl: user.photoURL,
        ),
        null,
      );
    } on fb.FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password' || e.code == 'user-not-found') {
        return (null, const AuthFailure.invalidCredentials());
      }
      if (e.code == 'network-request-failed') {
        return (null, const AuthFailure.network());
      }
      return (null, AuthFailure.unexpected(e.message ?? e.code));
    } catch (e) {
      return (null, const AuthFailure.network());
    }
  }

  Future<(AuthUser?, AuthFailure?)> signUpWithEmailPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final cred = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = cred.user;
      if (user == null) {
        return (null, const AuthFailure.unexpected('No user returned'));
      }

      if (displayName != null && displayName.isNotEmpty) {
        await user.updateDisplayName(displayName);
        await user.reload();
        final updatedUser = _firebaseAuth.currentUser;
        if (updatedUser != null) {
          return (
            AuthUser(
              id: updatedUser.uid,
              email: updatedUser.email ?? '',
              displayName: updatedUser.displayName,
              photoUrl: updatedUser.photoURL,
            ),
            null,
          );
        }
      }

      return (
        AuthUser(
          id: user.uid,
          email: user.email ?? '',
          displayName: user.displayName,
          photoUrl: user.photoURL,
        ),
        null,
      );
    } on fb.FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return (null, const AuthFailure.emailAlreadyInUse());
      }
      if (e.code == 'weak-password') {
        return (null, const AuthFailure.weakPassword());
      }
      if (e.code == 'network-request-failed') {
        return (null, const AuthFailure.network());
      }
      return (null, AuthFailure.unexpected(e.message ?? e.code));
    } catch (e) {
      return (null, const AuthFailure.network());
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}

