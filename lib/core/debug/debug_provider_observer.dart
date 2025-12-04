import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'debug_config.dart';
import 'debug_utils.dart';

/// Extracts a clean, readable name from a provider.
///
/// Prefers provider.name if set, otherwise extracts a meaningful name
/// from the runtime type (e.g., "AuthViewModel" from "StateNotifierProvider<AuthViewModel, AuthState>").
String _extractProviderName(ProviderBase<Object?> provider) {
  if (provider.name != null && provider.name!.isNotEmpty) {
    return provider.name!;
  }

  final typeStr = provider.runtimeType.toString();

  // Extract meaningful name from generic types like:
  // "StateNotifierProvider<AuthViewModel, AuthState>" -> "AuthViewModel"
  // "Provider<AuthService>" -> "AuthService"
  final match = RegExp(r'<(\w+)').firstMatch(typeStr);
  if (match != null) {
    return match.group(1)!;
  }

  // Fallback to the type name without generics
  return typeStr.split('<').first;
}

/// Formats state value for debug output.
///
/// Uses toString() if it provides meaningful information,
/// otherwise shows just the type name.
String _formatStateValue(Object? value) {
  if (value == null) {
    return 'null';
  }

  final str = value.toString();
  // If toString() is the default (starts with "Instance of"), just show type
  if (str.startsWith('Instance of ')) {
    return value.runtimeType.toString();
  }

  // Otherwise use the custom toString() which should have useful info
  return str;
}

/// Checks if a provider should be logged based on configuration.
bool _shouldLogProvider(ProviderBase<Object?> provider, String providerName) {
  // Check if provider logging is disabled
  if (!DebugConfig.enableProviderLogging) {
    return false;
  }

  final nameLower = providerName.toLowerCase();

  // Check whitelist (if non-empty, only log included providers)
  final included = DebugConfig.includedProviderNames;
  if (included.isNotEmpty && !included.contains(nameLower)) {
    return false;
  }

  // Check blacklist
  if (DebugConfig.excludedProviderNames.contains(nameLower)) {
    return false;
  }

  // Check if it's a StreamProvider and logging is disabled
  final typeStr = provider.runtimeType.toString();
  if (typeStr.contains('StreamProvider') && !DebugConfig.logStreamProviders) {
    return false;
  }

  // Check if it's an autoDispose provider and logging is disabled
  if (typeStr.contains('AutoDispose') && !DebugConfig.logAutoDisposeProviders) {
    return false;
  }

  return true;
}

/// Riverpod provider observer that logs provider lifecycle and state changes.
///
/// Only active when [DebugConfig.enableProviderLogging] is true.
/// Automatically disabled in release mode.
class DebugProviderObserver extends ProviderObserver {
  @override
  void didAddProvider(
    ProviderBase<Object?> provider,
    Object? value,
    ProviderContainer container,
  ) {
    final providerName = _extractProviderName(provider);
    if (!_shouldLogProvider(provider, providerName)) {
      return;
    }

    final stateStr = _formatStateValue(value);
    debugLog('ProviderObserver', '$providerName added', stateStr);
  }

  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    final providerName = _extractProviderName(provider);
    if (!_shouldLogProvider(provider, providerName)) {
      return;
    }

    final prevStr = _formatStateValue(previousValue);
    final newStr = _formatStateValue(newValue);

    // Only log if state actually changed (not just reference equality)
    if (prevStr != newStr) {
      debugLog(
        'ProviderObserver',
        '$providerName updated',
        '$prevStr → $newStr',
      );
    }
  }

  @override
  void didDisposeProvider(
    ProviderBase<Object?> provider,
    ProviderContainer container,
  ) {
    final providerName = _extractProviderName(provider);
    if (!_shouldLogProvider(provider, providerName)) {
      return;
    }

    debugLog('ProviderObserver', '$providerName disposed');
  }

  @override
  void providerDidFail(
    ProviderBase<Object?> provider,
    Object error,
    StackTrace stackTrace,
    ProviderContainer container,
  ) {
    final providerName = _extractProviderName(provider);
    // Always log errors, even if provider is filtered
    if (!DebugConfig.enableProviderLogging) {
      return;
    }

    debugError('ProviderObserver', '$providerName failed', error, stackTrace);
  }
}
