import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../viewmodel/splash_view_model.dart';

class SplashViewPhone extends StatelessWidget {
  const SplashViewPhone({
    super.key,
    required this.state,
    required this.onRetry,
  });

  final SplashState state;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final platform = theme.platform;
    final isCupertino = platform == TargetPlatform.iOS ||
        platform == TargetPlatform.macOS ||
        platform == TargetPlatform.fuchsia;
    final indicator = isCupertino
        ? const CupertinoActivityIndicator(radius: 16)
        : const SizedBox(
            height: 32,
            width: 32,
            child: CircularProgressIndicator(strokeWidth: 3),
          );

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.primaryContainer,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const Spacer(),
                Icon(
                  Icons.meeting_room_outlined,
                  size: 88,
                  color: theme.colorScheme.onPrimary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Savage Coworking',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Setting up your workspace',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onPrimary.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 32),
                if (state.isLoading) indicator,
                if (!state.isLoading) const SizedBox(height: 32),
                if (state.errorMessage != null) ...[
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color:
                          theme.colorScheme.onPrimary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      state.errorMessage!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: state.isLoading ? null : onRetry,
                    style: FilledButton.styleFrom(
                      backgroundColor: theme.colorScheme.onPrimary,
                      foregroundColor: theme.colorScheme.primary,
                      minimumSize: const Size.fromHeight(48),
                    ),
                    child: const Text('Try again'),
                  ),
                ],
                const Spacer(),
                Text(
                  'Powered by flexible teams',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onPrimary.withOpacity(0.9),
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
