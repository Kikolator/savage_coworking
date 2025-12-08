import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/models/auth_user.dart';
import '../../subscription/models/subscription.dart';
import '../../subscription/service/subscription_service.dart';
import '../../workspace/view/widgets/create_workspace_dialog.dart';
import 'widgets/subscription_selection_cta.dart';
import 'widgets/workspace_selection_cta.dart';
import 'widgets/dashboard/quick_actions_card.dart';
import 'widgets/dashboard/subscription_info_card.dart';
import 'widgets/dashboard/upcoming_bookings_card.dart';
import 'widgets/dashboard/usage_stats_card.dart';

class HomeViewMobile extends ConsumerWidget {
  const HomeViewMobile({
    super.key,
    required this.userId,
    required this.hasSelectedWorkspace,
    required this.hasNoWorkspace,
    required this.user,
    required this.subscriptionService,
  });

  final String userId;
  final bool hasSelectedWorkspace;
  final bool hasNoWorkspace;
  final AuthUser user;
  final SubscriptionService subscriptionService;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Check for active subscription
    final subscriptionAsync = ref.watch(
      FutureProvider.autoDispose<Subscription?>((ref) async {
        final (subscription, _) = await subscriptionService
            .getActiveSubscription(userId);
        return subscription;
      }),
    );

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Admin workspace creation banner
            if (user.isAdmin && hasNoWorkspace) _AdminWorkspaceBanner(),
            if (user.isAdmin && hasNoWorkspace) const SizedBox(height: 16),

            // Workspace selection CTA
            if (!hasSelectedWorkspace) ...[
              const WorkspaceSelectionCTA(),
              const SizedBox(height: 16),
            ],

            // Subscription selection CTA (only if workspace is selected)
            if (hasSelectedWorkspace) ...[
              subscriptionAsync.when(
                data: (subscription) {
                  if (subscription == null || !subscription.isActive) {
                    return const SubscriptionSelectionCTA();
                  }
                  return const SizedBox.shrink();
                },
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (_, __) => const SizedBox.shrink(),
              ),
              if (subscriptionAsync.valueOrNull == null ||
                  !subscriptionAsync.valueOrNull!.isActive)
                const SizedBox(height: 16),
            ],

            // Dashboard widgets (only if workspace and subscription are set)
            if (hasSelectedWorkspace)
              subscriptionAsync.when(
                data: (subscription) {
                  if (subscription != null && subscription.isActive) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        UpcomingBookingsCard(userId: userId),
                        const SizedBox(height: 16),
                        QuickActionsCard(),
                        const SizedBox(height: 16),
                        SubscriptionInfoCard(subscription: subscription),
                        const SizedBox(height: 16),
                        UsageStatsCard(
                          userId: userId,
                          subscription: subscription,
                        ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (_, __) => const SizedBox.shrink(),
              ),
          ],
        ),
      ),
    );
  }
}

class _AdminWorkspaceBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning,
            color: Theme.of(context).colorScheme.onErrorContainer,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'No workspace found. Create a workspace to continue.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
            ),
          ),
          const SizedBox(width: 12),
          FilledButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => CreateWorkspaceDialog(
                  onWorkspaceCreated: () {
                    // Workspace created, banner will disappear
                  },
                ),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.onErrorContainer,
              foregroundColor: Theme.of(context).colorScheme.errorContainer,
            ),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}
