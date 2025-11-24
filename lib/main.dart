import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';
import 'core/config/firebase_emulator_config.dart';
import 'core/debug/debug_config.dart';
import 'core/debug/debug_provider_observer.dart';
import 'features/hot_desk_booking/view/hot_desk_booking_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  connectFirebaseEmulators();

  // Initialize debug configuration
  DebugConfig.initialize();

  // Create debug observer (only active in debug mode)
  final debugObserver = DebugProviderObserver();

  runApp(ProviderScope(observers: [debugObserver], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Savage Coworking',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HotDeskBookingView(),
    );
  }
}
