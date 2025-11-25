import 'dart:async';
import 'package:flutter/material.dart';

/// A [ChangeNotifier] that wraps a [Stream] to work with GoRouter's [refreshListenable].
///
/// This allows GoRouter to react to stream changes and refresh route redirects
/// when the stream emits new values.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.listen((_) {
      notifyListeners();
    });
  }

  StreamSubscription<dynamic>? _subscription;

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

