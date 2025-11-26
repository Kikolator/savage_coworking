import 'package:flutter/material.dart';

import '../../../models/admin_dashboard_data.dart';
import 'admin_section_detail_list.dart';

class AdminAnalyticsSection extends StatelessWidget {
  const AdminAnalyticsSection({super.key, required this.details});

  final List<AdminSectionDetail> details;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Analytics',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        AdminSectionDetailList(
          details: details,
          emptyLabel: 'No analytics insights right now.',
        ),
      ],
    );
  }
}
