import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/subscription_plan.dart';
import '../../providers/subscription_providers.dart';

class ChoosePlanDialog extends ConsumerWidget {
  const ChoosePlanDialog({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(subscriptionViewModelProvider(userId).notifier);
    final state = ref.watch(subscriptionViewModelProvider(userId));

    // Load plans if not already loaded
    if (state.plans == null && !state.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        viewModel.loadPlans();
      });
    }

    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Choose a Subscription Plan',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (state.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (state.plans == null || state.plans!.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text('No plans available'),
                ),
              )
            else
              Expanded(
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: state.plans!
                        .map((plan) => PlanCard(plan: plan))
                        .toList(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class PlanCard extends StatelessWidget {
  const PlanCard({super.key, required this.plan});

  final SubscriptionPlan plan;

  @override
  Widget build(BuildContext context) {
    final isUnlimitedDesk = plan.deskHours == 0;
    final isUnlimitedMeeting = plan.meetingRoomHours == 0;

    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () {
          if (kDebugMode) {
            debugPrint(
              'ChoosePlanDialog: Plan selected - ${plan.name} (${plan.id})',
            );
          }
          Navigator.of(context).pop(plan);
        },
        child: Container(
          width: 250,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                plan.name,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plan.formattedPrice,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      '/${plan.billingCycle.toLowerCase()}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              _FeatureRow(
                icon: Icons.desk,
                label: 'Desk Hours',
                value: isUnlimitedDesk
                    ? 'Unlimited'
                    : '${plan.deskHours.toStringAsFixed(0)} hours',
              ),
              const SizedBox(height: 12),
              _FeatureRow(
                icon: Icons.meeting_room,
                label: 'Meeting Room Hours',
                value: isUnlimitedMeeting
                    ? 'Unlimited'
                    : '${plan.meetingRoomHours.toStringAsFixed(0)} hours',
              ),
              if (plan.features.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
                ...plan.features.map(
                  (feature) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Icon(Icons.check, size: 16, color: Colors.green[700]),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            feature,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (kDebugMode) {
                      debugPrint(
                        'ChoosePlanDialog: Plan selected via button - '
                        '${plan.name} (${plan.id})',
                      );
                    }
                    Navigator.of(context).pop(plan);
                  },
                  child: const Text('Select Plan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[700]),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 14),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }
}

