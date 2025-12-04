import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user.dart';

class UserRepository {
  UserRepository(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<User> get _collection => _firestore
      .collection('users')
      .withConverter(
        fromFirestore: (snapshot, _) {
          final data = snapshot.data();
          if (data == null) {
            throw StateError('User document ${snapshot.id} is empty');
          }
          return User.fromJson({...data, 'id': snapshot.id});
        },
        toFirestore: (user, _) {
          final json = user.toJson();
          // Remove id from json as it's the document ID
          json.remove('id');
          return json;
        },
      );

  /// Creates a new user document in Firestore.
  /// Returns the created user or throws an exception on failure.
  Future<User> createUser({
    required String id,
    required String email,
    String? displayName,
    String? photoUrl,
  }) async {
    final now = DateTime.now().toUtc();
    final user = User(
      id: id,
      email: email,
      displayName: displayName,
      photoUrl: photoUrl,
      createdAt: now,
      updatedAt: now,
    );

    await _collection.doc(id).set(user);
    return user;
  }

  /// Gets a user document by ID.
  /// Returns null if the user doesn't exist.
  Future<User?> getUser(String id) async {
    final doc = await _collection.doc(id).get();
    if (!doc.exists) return null;
    return doc.data();
  }

  /// Watches a user document by ID.
  /// Returns a stream that emits the user whenever the document changes.
  /// Returns null if the user doesn't exist.
  Stream<User?> watchUser(String id) {
    return _collection.doc(id).snapshots().map((snapshot) {
      if (!snapshot.exists) return null;
      try {
        return snapshot.data();
      } catch (e) {
        // Handle errors gracefully by returning null
        return null;
      }
    });
  }

  /// Checks if a user document exists.
  Future<bool> userExists(String id) async {
    final doc = await _collection.doc(id).get();
    return doc.exists;
  }

  /// Updates a user document.
  /// Automatically updates the updatedAt timestamp.
  Future<void> updateUser(String id, {
    String? displayName,
    String? photoUrl,
  }) async {
    final updates = <String, dynamic>{
      'updatedAt': Timestamp.fromDate(DateTime.now().toUtc()),
    };

    if (displayName != null) {
      updates['displayName'] = displayName;
    }
    if (photoUrl != null) {
      updates['photoUrl'] = photoUrl;
    }

    await _collection.doc(id).update(updates);
  }

  /// Updates the selected workspace ID for a user.
  /// Automatically updates the updatedAt timestamp.
  Future<void> updateSelectedWorkspace(String id, String? workspaceId) async {
    final updates = <String, dynamic>{
      'updatedAt': Timestamp.fromDate(DateTime.now().toUtc()),
      'selectedWorkspaceId': workspaceId,
    };

    await _collection.doc(id).update(updates);
  }
}


