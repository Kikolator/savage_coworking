import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/workspace.dart';

class WorkspaceRepository {
  WorkspaceRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Workspace> get _collection => _firestore
      .collection('workspaces')
      .withConverter(
        fromFirestore: (snapshot, _) {
          final data = snapshot.data();
          if (data == null) {
            throw StateError('Workspace document ${snapshot.id} is empty');
          }
          return Workspace.fromJson({...data, 'id': snapshot.id});
        },
        toFirestore: (workspace, _) => workspace.toJson(),
      );

  Stream<List<Workspace>> watchWorkspaces() {
    return _collection
        .where('isActive', isEqualTo: true)
        .orderBy('name')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) => doc.data()).toList(),
        );
  }

  Future<List<Workspace>> fetchWorkspaces() async {
    final snapshot = await _collection
        .where('isActive', isEqualTo: true)
        .orderBy('name')
        .get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<Workspace?> getWorkspace(String workspaceId) async {
    final doc = await _collection.doc(workspaceId).get();
    if (!doc.exists) return null;
    return doc.data();
  }

  Future<Workspace> createWorkspace(Workspace workspace) async {
    final docRef =
        workspace.id.isEmpty ? _collection.doc() : _collection.doc(workspace.id);
    final workspaceToSave = workspace.copyWith(id: docRef.id);
    await docRef.set(workspaceToSave);
    return workspaceToSave;
  }

  Future<void> updateWorkspace(String workspaceId, Map<String, dynamic> data) {
    data['updatedAt'] = Timestamp.fromDate(DateTime.now().toUtc());
    return _collection.doc(workspaceId).update(data);
  }

  Future<void> deleteWorkspace(String workspaceId) {
    return _collection.doc(workspaceId).delete();
  }
}

