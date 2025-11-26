import 'admin_dashboard_section.dart';

class AdminDashboardData {
  const AdminDashboardData({
    required this.summaryCards,
    required this.sectionDetails,
  });

  final List<AdminSummaryCardData> summaryCards;
  final Map<AdminDashboardSection, List<AdminSectionDetail>> sectionDetails;

  List<AdminSectionDetail> detailsFor(AdminDashboardSection section) {
    return sectionDetails[section] ?? const [];
  }
}

class AdminSummaryCardData {
  const AdminSummaryCardData({
    required this.title,
    required this.value,
    required this.trendLabel,
    required this.trendDelta,
  });

  final String title;
  final String value;
  final String trendLabel;
  final double trendDelta;
}

class AdminSectionDetail {
  const AdminSectionDetail({
    required this.title,
    required this.subtitle,
    required this.status,
    this.trailing,
  });

  final String title;
  final String subtitle;
  final String status;
  final String? trailing;
}
