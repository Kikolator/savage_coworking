import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/auth_user.dart';
import '../repository/auth_repository.dart';
import '../service/auth_service.dart';
import '../viewmodel/auth_view_model.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  return AuthRepository(firebaseAuth);
});

final authServiceProvider = Provider<AuthService>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return AuthService(repo);
});

final authStateChangesProvider = StreamProvider<AuthUser?>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.authStateChanges;
});

final authViewModelProvider =
    StateNotifierProvider<AuthViewModel, AuthState>((ref) {
  final service = ref.watch(authServiceProvider);
  return AuthViewModel(service);
});

