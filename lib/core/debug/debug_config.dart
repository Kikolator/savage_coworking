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

  /// Whether to log StreamProvider updates.
  ///
  /// StreamProviders can emit frequently and clutter logs.
  /// Set to false to filter out StreamProvider updates.
  static bool get logStreamProviders => kDebugMode && _logStreamProviders;

  /// Whether to log autoDispose provider lifecycle events.
  ///
  /// autoDispose providers can create/dispose frequently.
  /// Set to false to reduce noise.
  static bool get logAutoDisposeProviders =>
      kDebugMode && _logAutoDisposeProviders;

  /// Provider names to exclude from logging (case-insensitive).
  ///
  /// Useful for filtering out noisy providers.
  static Set<String> get excludedProviderNames => _excludedProviderNames;

  /// Provider names to include in logging (case-insensitive).
  ///
  /// If non-empty, only these providers will be logged (whitelist mode).
  /// Empty means all providers are logged (unless excluded).
  static Set<String> get includedProviderNames => _includedProviderNames;

  // Internal flags (can be modified for testing or advanced use cases)
  static bool _enableDebugLogging = true;
  static bool _enableProviderLogging = true;
  static bool _enableStateInspection = true;
  static bool _logStreamProviders = false; // Changed default to false
  static bool _logAutoDisposeProviders = true;
  static final Set<String> _excludedProviderNames = <String>{
    // Add commonly noisy providers here
    'currentUserDocumentProvider',
    'authStateChangesProvider',
  };
  static final Set<String> _includedProviderNames = <String>{};

  /// Initialize debug configuration.
  ///
  /// This method can be called at app startup to configure debug behavior.
  /// All flags default to true in debug mode.
  static void initialize({
    bool? enableDebugLogging,
    bool? enableProviderLogging,
    bool? enableStateInspection,
    bool? logStreamProviders,
    bool? logAutoDisposeProviders,
    Set<String>? excludedProviderNames,
    Set<String>? includedProviderNames,
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
    if (logStreamProviders != null) {
      _logStreamProviders = logStreamProviders;
    }
    if (logAutoDisposeProviders != null) {
      _logAutoDisposeProviders = logAutoDisposeProviders;
    }
    if (excludedProviderNames != null) {
      _excludedProviderNames.clear();
      _excludedProviderNames.addAll(
        excludedProviderNames.map((e) => e.toLowerCase()),
      );
    }
    if (includedProviderNames != null) {
      _includedProviderNames.clear();
      _includedProviderNames.addAll(
        includedProviderNames.map((e) => e.toLowerCase()),
      );
    }
  }

  /// Add a provider name to the exclusion list.
  static void excludeProvider(String providerName) {
    if (!kDebugMode) return;
    _excludedProviderNames.add(providerName.toLowerCase());
  }

  /// Remove a provider name from the exclusion list.
  static void includeProvider(String providerName) {
    if (!kDebugMode) return;
    _excludedProviderNames.remove(providerName.toLowerCase());
  }

  /// Reset all debug flags to their default values (true in debug mode).
  static void reset() {
    if (!kDebugMode) {
      return;
    }
    _enableDebugLogging = true;
    _enableProviderLogging = true;
    _enableStateInspection = true;
    _logStreamProviders = false;
    _logAutoDisposeProviders = true;
    _excludedProviderNames.clear();
    _excludedProviderNames.addAll({
      'currentUserDocumentProvider',
      'authStateChangesProvider',
    });
    _includedProviderNames.clear();
  }
}
