import 'package:flutter/foundation.dart';

import '../models/auth_user.dart';
import '../models/auth_failure.dart';
import '../repository/auth_repository.dart';
import '../repository/user_repository.dart';

class AuthService {
  final AuthRepository _authRepo;
  final UserRepository _userRepo;

  AuthService(this._authRepo, this._userRepo);

  Future<(AuthUser?, AuthFailure?)> login({
    required String email,
    required String password,
  }) {
    return _authRepo.signInWithEmailPassword(
      email: email,
      password: password,
    );
  }

  Future<(AuthUser?, AuthFailure?)> signUp({
    required String email,
    required String password,
    String? displayName,
  }) async {
    // First, create the Firebase Auth user
    final (authUser, authFailure) = await _authRepo.signUpWithEmailPassword(
      email: email,
      password: password,
      displayName: displayName,
    );

    if (authFailure != null || authUser == null) {
      return (null, authFailure);
    }

    // Then, create the Firestore user document
    // Check if user document already exists (in case of retry)
    final userExists = await _userRepo.userExists(authUser.id);
    if (!userExists) {
      try {
        await _userRepo.createUser(
          id: authUser.id,
          email: authUser.email,
          displayName: authUser.displayName,
          photoUrl: authUser.photoUrl,
        );
      } catch (e) {
        // Log error but don't fail the signup
        // The user is authenticated, and the document can be created later if needed
        // In production, you might want to use a logging service here
        debugPrint('Failed to create user document: $e');
      }
    }

    return (authUser, null);
  }

  Future<AuthUser?> getCurrentUser() {
    return _authRepo.getCurrentUser();
  }

  Future<void> logout() {
    return _authRepo.signOut();
  }

  Future<void> resetPassword(String email) {
    return _authRepo.sendPasswordResetEmail(email);
  }

  /// Switches the selected workspace for the current user.
  /// Updates the user document with the new selectedWorkspaceId.
  Future<String?> switchWorkspace(String userId, String workspaceId) async {
    try {
      await _userRepo.updateSelectedWorkspace(userId, workspaceId);
      return null;
    } catch (e) {
      return 'Failed to switch workspace: ${e.toString()}';
    }
  }
}

