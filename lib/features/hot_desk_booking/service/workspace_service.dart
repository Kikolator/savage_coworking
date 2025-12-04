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
    required String location,
    required String country,
    String? companyLogoUrl,
  }) async {
    final validationError = _validateWorkspaceData(
      name: name,
      location: location,
      country: country,
    );
    if (validationError != null) {
      return (null, validationError);
    }

    final now = DateTime.now().toUtc();
    final workspace = Workspace(
      id: '',
      name: name.trim(),
      location: location.trim(),
      country: country.trim(),
      companyLogoUrl: companyLogoUrl,
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
    String? location,
    String? country,
    String? companyLogoUrl,
    bool? isActive,
  }) async {
    final validationError = _validateWorkspaceData(
      name: name,
      location: location,
      country: country,
    );
    if (validationError != null) {
      return validationError;
    }

    try {
      final updates = <String, dynamic>{};
      if (name != null) {
        updates['name'] = name.trim();
      }
      if (location != null) {
        updates['location'] = location.trim();
      }
      if (country != null) {
        updates['country'] = country.trim();
      }
      if (companyLogoUrl != null) {
        updates['companyLogoUrl'] = companyLogoUrl;
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
    String? location,
    String? country,
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
    if (location != null) {
      final trimmed = location.trim();
      if (trimmed.isEmpty) {
        return 'Location is required';
      }
      if (trimmed.length > 200) {
        return 'Location must be 200 characters or less';
      }
    }
    if (country != null) {
      final trimmed = country.trim();
      if (trimmed.isEmpty) {
        return 'Country is required';
      }
      if (trimmed.length > 100) {
        return 'Country must be 100 characters or less';
      }
    }
    return null;
  }
}
