import '../models/workspace.dart';
import '../repository/workspace_repository.dart';

class WorkspaceService {
  WorkspaceService(this._repository);

  final WorkspaceRepository _repository;

  Stream<List<Workspace>> watchActiveWorkspaces() {
    return _repository.watchWorkspaces();
  }

  Future<List<Workspace>> fetchActiveWorkspaces() async {
    return _repository.fetchWorkspaces();
  }

  Future<(Workspace?, String?)> createWorkspace({
    required String name,
  }) async {
    final validationError = _validateWorkspaceData(name: name);
    if (validationError != null) {
      return (null, validationError);
    }

    final now = DateTime.now().toUtc();
    final workspace = Workspace(
      id: '',
      name: name.trim(),
      isActive: true,
      createdAt: now,
      updatedAt: now,
    );

    try {
      final saved = await _repository.createWorkspace(workspace);
      return (saved, null);
    } catch (e) {
      return (null, 'Failed to create workspace: ${e.toString()}');
    }
  }

  Future<String?> updateWorkspace(
    String workspaceId, {
    String? name,
    bool? isActive,
  }) async {
    if (name != null) {
      final validationError = _validateWorkspaceData(name: name);
      if (validationError != null) {
        return validationError;
      }
    }

    try {
      final updates = <String, dynamic>{};
      if (name != null) {
        updates['name'] = name.trim();
      }
      if (isActive != null) {
        updates['isActive'] = isActive;
      }
      await _repository.updateWorkspace(workspaceId, updates);
      return null;
    } catch (e) {
      return 'Failed to update workspace: ${e.toString()}';
    }
  }

  Future<String?> deleteWorkspace(String workspaceId) async {
    try {
      await _repository.deleteWorkspace(workspaceId);
      return null;
    } catch (e) {
      return 'Failed to delete workspace: ${e.toString()}';
    }
  }

  String? _validateWorkspaceData({
    String? name,
  }) {
    if (name != null) {
      final trimmed = name.trim();
      if (trimmed.isEmpty) {
        return 'Workspace name is required';
      }
      if (trimmed.length > 100) {
        return 'Workspace name must be 100 characters or less';
      }
    }
    return null;
  }
}

