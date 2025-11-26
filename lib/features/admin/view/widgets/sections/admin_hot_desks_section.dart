import 'package:flutter/material.dart';

import '../../../models/admin_dashboard_data.dart';
import 'admin_section_detail_list.dart';

class AdminHotDesksSection extends StatelessWidget {
  const AdminHotDesksSection({super.key, required this.details});

  final List<AdminSectionDetail> details;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hot desks',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        AdminSectionDetailList(
          details: details,
          emptyLabel: 'No desk insights yet.',
        ),
      ],
    );
  }
}
