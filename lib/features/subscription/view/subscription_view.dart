import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/models/auth_user.dart';
import '../../auth/providers/auth_providers.dart';
import '../../auth/view/auth_view.dart';
import '../models/subscription_failure.dart';
import '../models/subscription_plan.dart';
import '../providers/subscription_providers.dart';
import '../viewmodel/subscription_view_model.dart';
import 'subscription_view.desktop.dart';
import 'subscription_view.mobile.dart';
import 'subscription_view.tablet.dart';
import 'widgets/choose_plan_dialog.dart';

class SubscriptionView extends ConsumerWidget {
  const SubscriptionView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authViewModelProvider);
    final width = MediaQuery.of(context).size.width;

    if (authState.user == null) {
      return const AuthView();
    }

    final userId = authState.user!.id;
    final state = ref.watch(subscriptionViewModelProvider(userId));
    final viewModel =
        ref.read(subscriptionViewModelProvider(userId).notifier);

    ref.listen<SubscriptionFailure?>(
      subscriptionViewModelProvider(userId).select((state) => state.failure),
      (previous, next) {
        if (next == null) return;
        final messenger = ScaffoldMessenger.of(context);
        messenger.showSnackBar(SnackBar(content: Text(_failureMessage(next))));
        viewModel.clearFailure();
      },
    );

    Widget view;

    if (width >= 769) {
      view = SubscriptionViewDesktop(
        state: state,
        user: authState.user!,
        onChoosePlan: () => _showChoosePlanDialog(context, ref, userId),
        onCancelSubscription: (cancelAtPeriodEnd) =>
            viewModel.cancelSubscription(cancelAtPeriodEnd: cancelAtPeriodEnd),
        onRefresh: viewModel.refresh,
      );
    } else if (width >= 481) {
      view = SubscriptionViewTablet(
        state: state,
        user: authState.user!,
        onChoosePlan: () => _showChoosePlanDialog(context, ref, userId),
        onCancelSubscription: (cancelAtPeriodEnd) =>
            viewModel.cancelSubscription(cancelAtPeriodEnd: cancelAtPeriodEnd),
        onRefresh: viewModel.refresh,
      );
    } else {
      view = SubscriptionViewMobile(
        state: state,
        user: authState.user!,
        onChoosePlan: () => _showChoosePlanDialog(context, ref, userId),
        onCancelSubscription: (cancelAtPeriodEnd) =>
            viewModel.cancelSubscription(cancelAtPeriodEnd: cancelAtPeriodEnd),
        onRefresh: viewModel.refresh,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscription'),
      ),
      body: view,
    );
  }

  Future<void> _showChoosePlanDialog(
    BuildContext context,
    WidgetRef ref,
    String userId,
  ) async {
    if (kDebugMode) {
      debugPrint('SubscriptionView: Opening choose plan dialog for user $userId');
    }

    final selectedPlan = await showDialog<SubscriptionPlan>(
      context: context,
      builder: (context) => ChoosePlanDialog(userId: userId),
    );

    if (selectedPlan == null) {
      if (kDebugMode) {
        debugPrint('SubscriptionView: Plan selection cancelled');
      }
      return;
    }

    if (!context.mounted) {
      if (kDebugMode) {
        debugPrint('SubscriptionView: Context no longer mounted, aborting');
      }
      return;
    }

    if (kDebugMode) {
      debugPrint(
        'SubscriptionView: Plan selected - ${selectedPlan.name} '
        '(${selectedPlan.id}), initiating subscription flow',
      );
    }

    final viewModel =
        ref.read(subscriptionViewModelProvider(userId).notifier);
    await viewModel.selectPlan(selectedPlan);
  }

  String _failureMessage(SubscriptionFailure failure) {
    return failure.when(
      validation: (message) => message,
      notFound: () => 'Subscription not found',
      notAuthenticated: () => 'You are not authenticated',
      network: () => 'Network error. Please try again.',
      unexpected: (message) => 'Unexpected error: $message',
    );
  }
}

typedef SubscriptionViewBuilder = Widget Function(SubscriptionViewProps props);

class SubscriptionViewProps {
  const SubscriptionViewProps({
    required this.state,
    required this.user,
    required this.onChoosePlan,
    required this.onCancelSubscription,
    required this.onRefresh,
  });

  final SubscriptionState state;
  final AuthUser user;
  final VoidCallback onChoosePlan;
  final Future<void> Function(bool cancelAtPeriodEnd) onCancelSubscription;
  final VoidCallback onRefresh;
}

