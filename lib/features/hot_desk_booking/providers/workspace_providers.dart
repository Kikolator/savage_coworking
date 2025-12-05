import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/workspace_repository.dart';
import '../service/workspace_service.dart';
import '../models/workspace.dart';
import 'hot_desk_booking_providers.dart';

final workspaceRepositoryProvider = Provider<WorkspaceRepository>((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return WorkspaceRepository(firestore);
});

final workspaceServiceProvider = Provider<WorkspaceService>((ref) {
  final repository = ref.watch(workspaceRepositoryProvider);
  return WorkspaceService(repository);
});

final activeWorkspacesProvider = StreamProvider.autoDispose<List<Workspace>>(
  (ref) {
    final service = ref.watch(workspaceServiceProvider);
    return service.watchActiveWorkspaces();
  },
);

final activeWorkspacesFutureProvider =
    FutureProvider.autoDispose<List<Workspace>>((ref) {
  final service = ref.watch(workspaceServiceProvider);
  return service.fetchActiveWorkspaces();
});

final workspaceProvider = FutureProvider.autoDispose.family<Workspace?, String>(
  (ref, workspaceId) async {
    final repository = ref.watch(workspaceRepositoryProvider);
    return repository.getWorkspace(workspaceId);
  },
);

