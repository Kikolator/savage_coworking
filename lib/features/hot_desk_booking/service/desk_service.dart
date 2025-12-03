import '../models/desk.dart';
import '../repository/desk_repository.dart';
import '../repository/hot_desk_booking_repository.dart';

class DeskService {
  DeskService(this._repository, this._bookingRepository);

  final DeskRepository _repository;
  final HotDeskBookingRepository _bookingRepository;

  Stream<List<Desk>> watchAvailableDesks([String? workspaceId]) {
    return _repository.watchDesks(workspaceId).map(
          (desks) => desks.where((desk) => desk.isActive).toList(),
        );
  }

  Future<List<Desk>> fetchAvailableDesks([String? workspaceId]) async {
    final desks = await _repository.fetchDesks(workspaceId);
    return desks.where((desk) => desk.isActive).toList();
  }

  Future<(Desk?, String?)> createDesk({
    required String name,
    required String workspaceId,
    String? imageUrl,
    bool isActive = true,
  }) async {
    final validationError = _validateDeskData(name: name, workspaceId: workspaceId);
    if (validationError != null) {
      return (null, validationError);
    }

    final now = DateTime.now().toUtc();
    final desk = Desk(
      id: '',
      name: name.trim(),
      workspaceId: workspaceId.trim(),
      isActive: isActive,
      imageUrl: imageUrl,
      createdAt: now,
      updatedAt: now,
    );

    try {
      final saved = await _repository.createDesk(desk);
      return (saved, null);
    } catch (e) {
      return (null, 'Failed to create desk: ${e.toString()}');
    }
  }

  Future<String?> updateDesk(
    String deskId, {
    String? name,
    bool? isActive,
    String? imageUrl,
  }) async {
    if (name != null) {
      final validationError = _validateDeskData(name: name);
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
      if (imageUrl != null) {
        updates['imageUrl'] = imageUrl;
      }
      await _repository.updateDesk(deskId, updates);
      return null;
    } catch (e) {
      return 'Failed to update desk: ${e.toString()}';
    }
  }

  Future<String?> deleteDesk(String deskId) async {
    // Check for active bookings
    final desk = await _repository.getDesk(deskId);
    if (desk == null) {
      return 'Desk not found';
    }

    // Check if there are any active bookings for this desk
    final hasActiveBookings = await _bookingRepository.hasActiveBookingsForDesk(deskId);
    if (hasActiveBookings) {
      return 'Cannot delete desk with active bookings';
    }

    try {
      await _repository.deleteDesk(deskId);
      return null;
    } catch (e) {
      return 'Failed to delete desk: ${e.toString()}';
    }
  }

  String? _validateDeskData({
    String? name,
    String? workspaceId,
  }) {
    if (name != null) {
      final trimmed = name.trim();
      if (trimmed.isEmpty) {
        return 'Desk name is required';
      }
      if (trimmed.length > 100) {
        return 'Desk name must be 100 characters or less';
      }
    }
    if (workspaceId != null) {
      if (workspaceId.trim().isEmpty) {
        return 'Workspace ID is required';
      }
    }
    return null;
  }
}

