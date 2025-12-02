import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/auth_user.dart';
import '../repository/auth_repository.dart';
import '../repository/user_repository.dart';
import '../service/auth_service.dart';
import '../viewmodel/auth_view_model.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  return AuthRepository(firebaseAuth);
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return UserRepository(firestore);
});

final authServiceProvider = Provider<AuthService>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);
  final userRepo = ref.watch(userRepositoryProvider);
  return AuthService(authRepo, userRepo);
});

final authStateChangesProvider = StreamProvider<AuthUser?>((ref) {
  final repo = ref.watch(authRepositoryProvider);
  return repo.authStateChanges;
});

final authViewModelProvider = StateNotifierProvider<AuthViewModel, AuthState>((
  ref,
) {
  final service = ref.watch(authServiceProvider);
  final viewModel = AuthViewModel(service);

  // Sync view model with Firebase auth state changes
  ref.listen<AsyncValue<AuthUser?>>(authStateChangesProvider, (previous, next) {
    if (next.hasValue) {
      viewModel.syncUser(next.value);
    }
  });

  return viewModel;
});
