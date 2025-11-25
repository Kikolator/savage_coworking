import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/hot_desk_booking.dart';
import '../models/hot_desk_booking_status.dart';

class HotDeskBookingRepository {
  HotDeskBookingRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<HotDeskBooking> get _collection => _firestore
      .collection('deskBookings')
      .withConverter(
        fromFirestore: (snapshot, _) {
          final data = snapshot.data();
          if (data == null) {
            throw StateError('Booking document ${snapshot.id} is empty');
          }
          return HotDeskBooking.fromJson({...data, 'id': snapshot.id});
        },
        toFirestore: (booking, _) => booking.toJson(),
      );

  Stream<List<HotDeskBooking>> watchUserBookings(String userId) {
    return _collection
        .where('userId', isEqualTo: userId)
        .orderBy('startAt')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Future<List<HotDeskBooking>> fetchUserBookings(String userId) async {
    final snapshot = await _collection
        .where('userId', isEqualTo: userId)
        .orderBy('startAt')
        .get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<HotDeskBooking?> getBooking(String bookingId) async {
    final doc = await _collection.doc(bookingId).get();
    if (!doc.exists) return null;
    return doc.data();
  }

  Future<bool> hasConflictingBooking({
    required String deskId,
    required DateTime startAt,
    required DateTime endAt,
  }) async {
    final snapshot = await _collection
        .where('deskId', isEqualTo: deskId)
        .where(
          'status',
          whereIn: HotDeskBookingStatus.values
              .where((status) => status.isActive)
              .map((status) => status.name)
              .toList(),
        )
        .where('startAt', isLessThan: Timestamp.fromDate(endAt.toUtc()))
        .get();

    return snapshot.docs
        .map((doc) => doc.data())
        .any((booking) => booking.endAt.isAfter(startAt.toUtc()));
  }

  Future<HotDeskBooking> createBooking(HotDeskBooking booking) async {
    final docRef = booking.id.isEmpty
        ? _collection.doc()
        : _collection.doc(booking.id);
    final bookingToSave = booking.copyWith(id: docRef.id);
    await docRef.set(bookingToSave);
    return bookingToSave;
  }

  Future<void> updateBookingFields(
    String bookingId,
    Map<String, dynamic> data,
  ) {
    data['updatedAt'] = Timestamp.fromDate(DateTime.now().toUtc());
    return _collection.doc(bookingId).update(data);
  }
}
