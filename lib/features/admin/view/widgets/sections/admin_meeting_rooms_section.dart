import 'package:flutter/material.dart';

import '../../../models/admin_dashboard_data.dart';
import 'admin_section_detail_list.dart';

class AdminMeetingRoomsSection extends StatelessWidget {
  const AdminMeetingRoomsSection({super.key, required this.details});

  final List<AdminSectionDetail> details;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Meeting rooms',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        AdminSectionDetailList(
          details: details,
          emptyLabel: 'No meeting room updates.',
        ),
      ],
    );
  }
}
