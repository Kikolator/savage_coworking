import 'package:flutter/foundation.dart';

/// Application environment configuration.
///
/// Determines which Firebase project and configuration to use.
/// Can be set via `--dart-define=ENV=dev|prod` during build.
///
/// Default behavior:
/// - Debug builds → dev environment
/// - Release builds → prod environment (unless overridden)
enum AppEnvironment {
  /// Development environment (uses dev Firebase project)
  dev,

  /// Production environment (uses prod Firebase project)
  prod,
}

/// Provides access to the current application environment.
class AppEnvironmentConfig {
  AppEnvironmentConfig._();

  /// Gets the current environment from compile-time define or defaults based on build mode.
  ///
  /// Priority:
  /// 1. `--dart-define=ENV=dev|prod` (explicit override)
  /// 2. Debug mode → dev (backward compatible)
  /// 3. Release mode → prod (backward compatible)
  static AppEnvironment get current {
    const envString = String.fromEnvironment('ENV');
    
    if (envString.isNotEmpty) {
      switch (envString.toLowerCase()) {
        case 'dev':
        case 'development':
          return AppEnvironment.dev;
        case 'prod':
        case 'production':
          return AppEnvironment.prod;
        default:
          // Invalid value, fall back to default behavior
          if (kDebugMode) {
            debugPrint(
              'AppEnvironment: Invalid ENV value "$envString", defaulting to dev',
            );
            return AppEnvironment.dev;
          } else {
            debugPrint(
              'AppEnvironment: Invalid ENV value "$envString", defaulting to prod',
            );
            return AppEnvironment.prod;
          }
      }
    }

    // No explicit ENV define, use build mode as default
    return kDebugMode ? AppEnvironment.dev : AppEnvironment.prod;
  }

  /// Returns true if running in development environment.
  static bool get isDev => current == AppEnvironment.dev;

  /// Returns true if running in production environment.
  static bool get isProd => current == AppEnvironment.prod;
}

