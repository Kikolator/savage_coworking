import '../models/admin_dashboard_data.dart';
import '../repository/admin_dashboard_repository.dart';

class AdminDashboardService {
  AdminDashboardService(this._repository);

  final AdminDashboardRepository _repository;

  Future<AdminDashboardData> loadDashboardSnapshot({String? workspaceId}) async {
    return await _repository.fetchDashboardSnapshot(workspaceId: workspaceId);
  }
}
