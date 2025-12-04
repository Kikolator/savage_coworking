import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

/// Connects Firebase services to emulators when running in debug mode.
///
/// This function should be called after [Firebase.initializeApp()] and before
/// any Firebase services are used. It will only connect to emulators when
/// [kDebugMode] is true.
///
/// Platform-specific hostname handling:
/// - Web and iOS Simulator: uses 'localhost'
/// - Android Emulator: uses '10.0.2.2' (maps to host machine's localhost)
///
/// If emulators are not running, this function will gracefully fail without
/// crashing the app.
void connectFirebaseEmulators() {
  // Only connect to emulators in debug mode
  if (!kDebugMode) {
    return;
  }

  try {
    // Determine the correct hostname based on platform
    String host;
    if (kIsWeb) {
      // Web platform uses localhost
      host = 'localhost';
    } else {
      // Mobile platforms
      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          // Android emulator requires special hostname
          host = '10.0.2.2';
          break;
        case TargetPlatform.iOS:
        case TargetPlatform.macOS:
          // iOS simulator and macOS can use localhost
          host = 'localhost';
          break;
        default:
          // Fallback to localhost for other platforms
          host = 'localhost';
      }
    }

    // Connect Auth emulator (port 9095 from firebase.json)
    FirebaseAuth.instance.useAuthEmulator(host, 9095);

    // Connect Firestore emulator (port 8081 from firebase.json)
    FirebaseFirestore.instance.useFirestoreEmulator(host, 8081);

    // Connect Storage emulator (port 9198 from firebase.json)
    FirebaseStorage.instance.useStorageEmulator(host, 9198);
  } catch (e) {
    // Gracefully handle errors if emulators aren't running
    // This prevents crashes when emulators are not available
    debugPrint('Failed to connect to Firebase emulators: $e');
  }
}
