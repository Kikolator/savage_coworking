import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'app/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'firebase_options.dart';
import 'firebase_options_dev.dart' as dev;
import 'core/config/firebase_emulator_config.dart';
import 'core/debug/debug_config.dart';
import 'core/debug/debug_provider_observer.dart';

void main() async {
  // Use path-based URL strategy to remove # from URLs
  usePathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: kDebugMode
        ? dev.DefaultFirebaseOptions.currentPlatform
        : DefaultFirebaseOptions.currentPlatform,
  );
  connectFirebaseEmulators(
    useAuthEmulator: kDebugMode,
    useFirestoreEmulator: kDebugMode,
    useStorageEmulator: kDebugMode,
    useFunctionsEmulator: kDebugMode,
  );

  // Initialize debug configuration
  DebugConfig.initialize(enableProviderLogging: true);

  // Create debug observer (only active in debug mode)
  final debugObserver = DebugProviderObserver();

  runApp(ProviderScope(observers: [debugObserver], child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'Savage Coworking',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: router,
    );
  }
}
