import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/admin_subscription_providers.dart';
import 'subscriptions/admin_plan_list.dart';
import 'subscriptions/admin_subscription_list.dart';

class AdminSubscriptionsSection extends ConsumerStatefulWidget {
  const AdminSubscriptionsSection({super.key});

  @override
  ConsumerState<AdminSubscriptionsSection> createState() =>
      _AdminSubscriptionsSectionState();
}

class _AdminSubscriptionsSectionState
    extends ConsumerState<AdminSubscriptionsSection>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Load data when section is first shown
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(adminSubscriptionViewModelProvider.notifier).loadSubscriptions();
      ref.read(adminSubscriptionViewModelProvider.notifier).loadPlans();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(adminSubscriptionViewModelProvider);
    final viewModel = ref.read(adminSubscriptionViewModelProvider.notifier);

    // Show error/success messages
    if (state.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.errorMessage!),
            backgroundColor: theme.colorScheme.error,
          ),
        );
        viewModel.clearError();
      });
    }

    if (state.successMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.successMessage!),
            backgroundColor: theme.colorScheme.primary,
          ),
        );
        viewModel.clearSuccess();
      });
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Use a reasonable fixed height for TabBarView
        // If constraints are bounded, use them; otherwise use a default
        final double tabBarViewHeight;
        if (constraints.maxHeight.isFinite && constraints.maxHeight > 400) {
          tabBarViewHeight = constraints.maxHeight - 100; // Account for title and TabBar
        } else {
          tabBarViewHeight = 600.0; // Default height
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Subscriptions',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Subscriptions', icon: Icon(Icons.subscriptions)),
                Tab(text: 'Plans', icon: Icon(Icons.credit_card)),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: tabBarViewHeight,
              child: TabBarView(
                controller: _tabController,
                children: const [
                  AdminSubscriptionList(),
                  AdminPlanList(),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

