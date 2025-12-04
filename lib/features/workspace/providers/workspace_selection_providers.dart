import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/models/user.dart';
import '../../auth/providers/auth_providers.dart';
import '../../hot_desk_booking/models/workspace.dart';
import '../../hot_desk_booking/providers/workspace_providers.dart';

/// Provider that watches the current user's Firestore user document
final currentUserDocumentProvider = StreamProvider.autoDispose<User?>((ref) {
  final authState = ref.watch(authViewModelProvider);
  final authUser = authState.user;

  if (authUser == null) {
    return Stream.value(null);
  }

  final userRepository = ref.watch(userRepositoryProvider);
  return userRepository.watchUser(authUser.id);
});

/// Provider that watches the current user's selected workspace
final selectedWorkspaceProvider = StreamProvider.autoDispose<Workspace?>((ref) {
  final userDocAsync = ref.watch(currentUserDocumentProvider);

  return userDocAsync.when(
    data: (user) {
      if (user == null ||
          user.selectedWorkspaceId == null ||
          user.selectedWorkspaceId!.isEmpty) {
        return Stream.value(null);
      }

      final workspaceService = ref.watch(workspaceServiceProvider);
      return workspaceService.watchActiveWorkspaces().map((workspaces) {
        try {
          return workspaces.firstWhere(
            (ws) => ws.id == user.selectedWorkspaceId,
          );
        } catch (e) {
          return null;
        }
      });
    },
    loading: () => Stream.value(null),
    error: (_, __) => Stream.value(null),
  );
});

/// Provider that gets the current user's selected workspace ID
final selectedWorkspaceIdProvider = Provider.autoDispose<String?>((ref) {
  final userDocAsync = ref.watch(currentUserDocumentProvider);
  return userDocAsync.valueOrNull?.selectedWorkspaceId;
});

/// Helper function to switch workspace
Future<String?> switchWorkspace(
  WidgetRef ref,
  String userId,
  String workspaceId,
) async {
  final authService = ref.read(authServiceProvider);
  return await authService.switchWorkspace(userId, workspaceId);
}
