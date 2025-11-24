import 'package:flutter/foundation.dart';

/// Centralized debug configuration for the application.
///
/// All debug features are automatically disabled in release mode.
/// Individual feature flags can be toggled to control specific debug behaviors.
class DebugConfig {
  DebugConfig._();

  /// Whether debug logging is enabled.
  ///
  /// When true, debug utilities will output logs.
  /// Automatically false in release mode.
  static bool get enableDebugLogging => kDebugMode && _enableDebugLogging;

  /// Whether provider state logging is enabled.
  ///
  /// When true, Riverpod provider observer will log state changes.
  /// Automatically false in release mode.
  static bool get enableProviderLogging => kDebugMode && _enableProviderLogging;

  /// Whether state inspection utilities are enabled.
  ///
  /// When true, state inspection helpers will be active.
  /// Automatically false in release mode.
  static bool get enableStateInspection => kDebugMode && _enableStateInspection;

  // Internal flags (can be modified for testing or advanced use cases)
  static bool _enableDebugLogging = true;
  static bool _enableProviderLogging = true;
  static bool _enableStateInspection = true;

  /// Initialize debug configuration.
  ///
  /// This method can be called at app startup to configure debug behavior.
  /// All flags default to true in debug mode.
  static void initialize({
    bool? enableDebugLogging,
    bool? enableProviderLogging,
    bool? enableStateInspection,
  }) {
    if (!kDebugMode) {
      return;
    }

    if (enableDebugLogging != null) {
      _enableDebugLogging = enableDebugLogging;
    }
    if (enableProviderLogging != null) {
      _enableProviderLogging = enableProviderLogging;
    }
    if (enableStateInspection != null) {
      _enableStateInspection = enableStateInspection;
    }
  }

  /// Reset all debug flags to their default values (true in debug mode).
  static void reset() {
    if (!kDebugMode) {
      return;
    }
    _enableDebugLogging = true;
    _enableProviderLogging = true;
    _enableStateInspection = true;
  }
}
