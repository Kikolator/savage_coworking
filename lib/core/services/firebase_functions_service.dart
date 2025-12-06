import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Core service for calling Firebase Cloud Functions.
///
/// Handles emulator connection in debug mode and provides a clean interface
/// for calling callable functions.
class FirebaseFunctionsService {
  FirebaseFunctionsService() {
    _initialize();
  }

  late final FirebaseFunctions _functions;

  void _initialize() {
    _functions = FirebaseFunctions.instance;

    // Connect to emulator in debug mode
    if (kDebugMode) {
      _connectToEmulator();
    }
  }

  /// Connects to the Firebase Functions emulator when running in debug mode.
  void _connectToEmulator() {
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

      // Connect Functions emulator (port 5005 from firebase.json)
      _functions.useFunctionsEmulator(host, 5005);

      if (kDebugMode) {
        debugPrint(
          'FirebaseFunctionsService: Connected to emulator at $host:5005',
        );
      }
    } catch (e) {
      // Gracefully handle errors if emulators aren't running
      debugPrint('Failed to connect to Functions emulator: $e');
    }
  }

  /// Calls a Firebase callable function.
  ///
  /// [functionName] is the name of the callable function.
  /// [data] is the data to pass to the function (will be JSON encoded).
  ///
  /// Returns the result from the function call.
  /// Throws an exception if the call fails.
  Future<T> callFunction<T>({
    required String functionName,
    Map<String, dynamic>? data,
  }) async {
    try {
      final callable = _functions.httpsCallable(functionName);

      final result = await callable.call(data);

      // Extract data from HttpsCallableResult
      return result.data as T;
    } on FirebaseFunctionsException catch (e) {
      if (kDebugMode) {
        debugPrint(
          'FirebaseFunctionsService: Function $functionName failed: '
          '${e.code} - ${e.message}',
        );
      }
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        debugPrint(
          'FirebaseFunctionsService: Unexpected error calling $functionName: $e',
        );
      }
      rethrow;
    }
  }

  /// Calls a Firebase callable function and returns a typed result.
  ///
  /// This is a convenience method that handles common response patterns.
  Future<Map<String, dynamic>> callFunctionWithMap({
    required String functionName,
    Map<String, dynamic>? data,
  }) async {
    final result = await callFunction<Map<String, dynamic>>(
      functionName: functionName,
      data: data,
    );
    return result;
  }
}

