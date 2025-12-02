import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/desk.dart';

class DeskRepository {
  DeskRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Desk> get _collection => _firestore
      .collection('desks')
      .withConverter(
        fromFirestore: (snapshot, _) {
          final data = snapshot.data();
          if (data == null) {
            throw StateError('Desk document ${snapshot.id} is empty');
          }
          return Desk.fromJson({...data, 'id': snapshot.id});
        },
        toFirestore: (desk, _) => desk.toJson(),
      );

  Stream<List<Desk>> watchDesks([String? workspaceId]) {
    var query = _collection.orderBy('name');
    if (workspaceId != null && workspaceId.isNotEmpty) {
      query = query.where('workspaceId', isEqualTo: workspaceId);
    }
    return query.snapshots().map(
          (snapshot) => snapshot.docs.map((doc) => doc.data()).toList(),
        );
  }

  Future<List<Desk>> fetchDesks([String? workspaceId]) async {
    var query = _collection.orderBy('name');
    if (workspaceId != null && workspaceId.isNotEmpty) {
      query = query.where('workspaceId', isEqualTo: workspaceId);
    }
    final snapshot = await query.get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<Desk?> getDesk(String deskId) async {
    final doc = await _collection.doc(deskId).get();
    if (!doc.exists) return null;
    return doc.data();
  }

  Future<Desk> createDesk(Desk desk) async {
    final docRef = desk.id.isEmpty ? _collection.doc() : _collection.doc(desk.id);
    final deskToSave = desk.copyWith(id: docRef.id);
    await docRef.set(deskToSave);
    return deskToSave;
  }

  Future<void> updateDesk(String deskId, Map<String, dynamic> data) {
    data['updatedAt'] = Timestamp.fromDate(DateTime.now().toUtc());
    return _collection.doc(deskId).update(data);
  }

  Future<void> deleteDesk(String deskId) {
    return _collection.doc(deskId).delete();
  }
}

