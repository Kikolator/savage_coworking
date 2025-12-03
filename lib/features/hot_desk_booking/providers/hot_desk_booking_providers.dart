import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../service/hot_desk_booking_service.dart';
import '../viewmodel/hot_desk_booking_view_model.dart';
import '../repository/hot_desk_booking_repository.dart';
import '../../../core/services/storage_service.dart';

final firebaseFirestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final hotDeskBookingRepositoryProvider = Provider<HotDeskBookingRepository>((
  ref,
) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return HotDeskBookingRepository(firestore);
});

final hotDeskBookingServiceProvider = Provider<HotDeskBookingService>((ref) {
  final repository = ref.watch(hotDeskBookingRepositoryProvider);
  return HotDeskBookingService(repository);
});

final hotDeskBookingViewModelProvider = StateNotifierProvider.autoDispose
    .family<HotDeskBookingViewModel, HotDeskBookingState, String>((
      ref,
      userId,
    ) {
      final service = ref.watch(hotDeskBookingServiceProvider);
      return HotDeskBookingViewModel(service, userId);
    });

final firebaseStorageProvider = Provider<FirebaseStorage>((ref) {
  return FirebaseStorage.instance;
});

final storageServiceProvider = Provider<StorageService>((ref) {
  final storage = ref.watch(firebaseStorageProvider);
  return StorageService(storage);
});
