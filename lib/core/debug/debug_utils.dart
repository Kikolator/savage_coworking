import 'package:flutter/foundation.dart';
import 'debug_config.dart';

/// Formats an object for debug output.
///
/// Attempts to use toString() if it's not the default Object.toString().
/// Otherwise formats as a simple representation.
String _formatObject(Object? obj) {
  if (obj == null) {
    return 'null';
  }

  final str = obj.toString();
  // Check if it's the default Object.toString() (contains "Instance of")
  if (str.startsWith('Instance of ')) {
    // Try to extract useful information from the object
    // For state objects, we'll show the type name
    final typeName = obj.runtimeType.toString();
    return '$typeName';
  }

  // If toString() is overridden and provides useful info, use it
  return str;
}

/// Enhanced debug logging with formatted output.
///
/// Only logs when [DebugConfig.enableDebugLogging] is true.
void debugLog(String tag, String message, [Object? data]) {
  if (!DebugConfig.enableDebugLogging) {
    return;
  }

  final timestamp = DateTime.now().toIso8601String();
  final dataStr = data != null ? ' | ${_formatObject(data)}' : '';
  debugPrint('[$timestamp] [$tag] $message$dataStr');
}

/// Debug error logging with formatted output.
///
/// Only logs when [DebugConfig.enableDebugLogging] is true.
void debugError(
  String tag,
  String message, [
  Object? error,
  StackTrace? stackTrace,
]) {
  if (!DebugConfig.enableDebugLogging) {
    return;
  }

  final timestamp = DateTime.now().toIso8601String();
  final errorStr = error != null ? ' | Error: $error' : '';
  final stackStr = stackTrace != null ? '\n$stackTrace' : '';
  debugPrint('[$timestamp] [ERROR] [$tag] $message$errorStr$stackStr');
}

/// Debug warning logging with formatted output.
///
/// Only logs when [DebugConfig.enableDebugLogging] is true.
void debugWarning(String tag, String message, [Object? data]) {
  if (!DebugConfig.enableDebugLogging) {
    return;
  }

  final timestamp = DateTime.now().toIso8601String();
  final dataStr = data != null ? ' | Data: $data' : '';
  debugPrint('[$timestamp] [WARNING] [$tag] $message$dataStr');
}

/// Inspect and print state objects in a readable format.
///
/// Only active when [DebugConfig.enableStateInspection] is true.
void inspectState(String tag, String stateName, Object? state) {
  if (!DebugConfig.enableStateInspection) {
    return;
  }

  debugLog(tag, 'State Inspection: $stateName', state);
}

/// Debug provider state by inspecting its value.
///
/// Only active when [DebugConfig.enableStateInspection] is true.
void debugProviderState(String providerName, Object? value) {
  if (!DebugConfig.enableStateInspection) {
    return;
  }

  debugLog('Provider', 'Provider: $providerName', value);
}
