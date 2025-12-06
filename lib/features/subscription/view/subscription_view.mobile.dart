import 'package:flutter/material.dart';

import '../../auth/models/auth_user.dart';
import '../viewmodel/subscription_view_model.dart';
import 'widgets/no_subscription_card.dart';
import 'widgets/subscription_details_card.dart';

class SubscriptionViewMobile extends StatelessWidget {
  const SubscriptionViewMobile({
    super.key,
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

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.subscription == null) {
      return NoSubscriptionCard(onChoosePlan: onChoosePlan);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: SubscriptionDetailsCard(
        subscription: state.subscription!,
        onCancelSubscription: onCancelSubscription,
      ),
    );
  }
}

