import 'package:flutter/material.dart';

class NoSubscriptionCard extends StatelessWidget {
  const NoSubscriptionCard({super.key, required this.onChoosePlan});

  final VoidCallback onChoosePlan;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(24),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.subscriptions_outlined,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 24),
              const Text(
                'No Active Subscription',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Subscribe to a plan to start booking desks and meeting rooms.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: onChoosePlan,
                icon: const Icon(Icons.add),
                label: const Text('Choose a Plan'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


