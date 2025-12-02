import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/desk_repository.dart';
import '../service/desk_service.dart';
import '../models/desk.dart';
import 'hot_desk_booking_providers.dart';

final deskRepositoryProvider = Provider<DeskRepository>((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return DeskRepository(firestore);
});

final deskServiceProvider = Provider<DeskService>((ref) {
  final repository = ref.watch(deskRepositoryProvider);
  final bookingRepository = ref.watch(hotDeskBookingRepositoryProvider);
  return DeskService(repository, bookingRepository);
});

final availableDesksProvider = StreamProvider.autoDispose
    .family<List<Desk>, String?>((ref, workspaceId) {
  final service = ref.watch(deskServiceProvider);
  return service.watchAvailableDesks(workspaceId);
});

