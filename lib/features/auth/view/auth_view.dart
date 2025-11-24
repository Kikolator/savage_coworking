import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodel/auth_view_model.dart';
import '../providers/auth_providers.dart';
import 'auth_view.phone.dart';
import 'auth_view.tablet.dart';
import 'auth_view.desktop.dart';
import 'auth_view.monitor.dart';

class AuthView extends ConsumerWidget {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth >= 1280) {
      return const AuthViewMonitor();
    } else if (screenWidth >= 769) {
      return const AuthViewDesktop();
    } else if (screenWidth >= 481) {
      return const AuthViewTablet();
    } else {
      return const AuthViewPhone();
    }
  }
}

