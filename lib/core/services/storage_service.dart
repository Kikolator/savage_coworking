import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  StorageService(this._storage);

  final FirebaseStorage _storage;

  Future<String?> uploadDeskImage({
    required String deskId,
    required XFile imageFile,
  }) async {
    try {
      // Get file extension from name (works on both web and mobile)
      // On web, path is a blob URL, so we use name instead
      String extension = '';
      if (imageFile.name.isNotEmpty) {
        final parts = imageFile.name.split('.');
        if (parts.length > 1) {
          extension = parts.last.toLowerCase();
        }
      }

      // Fallback to path if name doesn't have extension (mobile)
      if (extension.isEmpty && imageFile.path.isNotEmpty) {
        final parts = imageFile.path.split('.');
        if (parts.length > 1) {
          extension = parts.last.toLowerCase();
        }
      }

      // Validate file extension
      if (extension.isEmpty ||
          !['jpg', 'jpeg', 'png', 'webp'].contains(extension)) {
        throw Exception('Invalid image format. Please use JPG, PNG, or WebP.');
      }

      // Create reference to storage location
      final ref = _storage.ref().child('desks/$deskId/image.$extension');

      // Upload file
      UploadTask uploadTask;
      if (kIsWeb) {
        uploadTask = ref.putData(await imageFile.readAsBytes());
      } else {
        uploadTask = ref.putFile(File(imageFile.path));
      }

      // Wait for upload to complete
      final snapshot = await uploadTask;

      // Get download URL
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload image: ${e.toString()}');
    }
  }

  Future<void> deleteDeskImage(String imageUrl) async {
    try {
      // Extract path from URL
      final ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      // Ignore errors when deleting (image might not exist)
      // Log error in production
    }
  }

  Future<String?> uploadWorkspaceLogo({
    required String workspaceId,
    required XFile imageFile,
  }) async {
    try {
      // Get file extension from name (works on both web and mobile)
      // On web, path is a blob URL, so we use name instead
      String extension = '';
      if (imageFile.name.isNotEmpty) {
        final parts = imageFile.name.split('.');
        if (parts.length > 1) {
          extension = parts.last.toLowerCase();
        }
      }

      // Fallback to path if name doesn't have extension (mobile)
      if (extension.isEmpty && imageFile.path.isNotEmpty) {
        final parts = imageFile.path.split('.');
        if (parts.length > 1) {
          extension = parts.last.toLowerCase();
        }
      }

      // Validate file extension
      if (extension.isEmpty ||
          !['jpg', 'jpeg', 'png', 'webp'].contains(extension)) {
        throw Exception('Invalid image format. Please use JPG, PNG, or WebP.');
      }

      // Create reference to storage location
      final ref = _storage.ref().child(
        'workspaces/$workspaceId/logo.$extension',
      );

      // Upload file
      UploadTask uploadTask;
      if (kIsWeb) {
        uploadTask = ref.putData(await imageFile.readAsBytes());
      } else {
        uploadTask = ref.putFile(File(imageFile.path));
      }

      // Wait for upload to complete
      final snapshot = await uploadTask;

      // Get download URL
      final downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload logo: ${e.toString()}');
    }
  }

  Future<void> deleteWorkspaceLogo(String imageUrl) async {
    try {
      // Extract path from URL
      final ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      // Ignore errors when deleting (image might not exist)
      // Log error in production
    }
  }
}
