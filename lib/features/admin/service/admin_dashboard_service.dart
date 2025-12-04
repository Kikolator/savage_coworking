import 'dart:async';

import '../models/admin_dashboard_data.dart';
import '../models/admin_dashboard_section.dart';

class AdminDashboardService {
  Future<AdminDashboardData> loadDashboardSnapshot({String? workspaceId}) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    // TODO: When real data is implemented, filter by workspaceId:
    // - Filter bookings by workspaceId
    // - Filter desks by workspaceId
    // - Calculate analytics for selected workspace only
    return AdminDashboardData(
      summaryCards: const [
        AdminSummaryCardData(
          title: 'Hot desk occupancy',
          value: '82%',
          trendLabel: 'vs last week',
          trendDelta: 6.2,
        ),
        AdminSummaryCardData(
          title: 'Meeting room utilization',
          value: '68%',
          trendLabel: 'vs last week',
          trendDelta: -3.4,
        ),
        AdminSummaryCardData(
          title: 'Monthly recurring revenue',
          value: '\$148k',
          trendLabel: 'vs forecast',
          trendDelta: 4.1,
        ),
        AdminSummaryCardData(
          title: 'Active members',
          value: '412',
          trendLabel: 'since Friday',
          trendDelta: 2.0,
        ),
      ],
      sectionDetails: {
        AdminDashboardSection.hotDesks: const [
          AdminSectionDetail(
            title: 'Workspace A',
            subtitle: '26 of 30 desks booked today',
            status: '87% occupancy',
            trailing: '+5% WoW',
          ),
          AdminSectionDetail(
            title: 'Workspace B',
            subtitle: '18 of 28 desks booked today',
            status: '64% occupancy',
            trailing: '-3% WoW',
          ),
          AdminSectionDetail(
            title: 'Waitlist',
            subtitle: '12 members waiting for recurring spots',
            status: 'Needs review',
          ),
        ],
        AdminDashboardSection.meetingRooms: const [
          AdminSectionDetail(
            title: 'Boardroom 1',
            subtitle: 'Booked 8:00a - 4:00p',
            status: 'Calendar full',
            trailing: 'Update AV kit',
          ),
          AdminSectionDetail(
            title: 'Strategy Lab',
            subtitle: '55% utilization this week',
            status: 'Available blocks',
            trailing: 'Promote 2pm-5pm',
          ),
        ],
        AdminDashboardSection.finance: const [
          AdminSectionDetail(
            title: 'MRR',
            subtitle: '\$148k current month',
            status: '+4.1% vs forecast',
            trailing: '\$6.2k delta',
          ),
          AdminSectionDetail(
            title: 'Outstanding invoices',
            subtitle: '9 invoices past due',
            status: 'Follow-ups needed',
          ),
          AdminSectionDetail(
            title: 'Upcoming renewals',
            subtitle: '24 contracts expiring within 30 days',
            status: 'Prepare offers',
          ),
        ],
        AdminDashboardSection.members: const [
          AdminSectionDetail(
            title: 'New members',
            subtitle: '12 onboarded this week',
            status: '+3 enterprise teams',
          ),
          AdminSectionDetail(
            title: 'Churn risk',
            subtitle: '7 members flagged',
            status: 'Requires outreach',
          ),
          AdminSectionDetail(
            title: 'NPS',
            subtitle: 'Score 56 (last 30 days)',
            status: 'Stable',
          ),
        ],
        AdminDashboardSection.analytics: const [
          AdminSectionDetail(
            title: 'Peak occupancy',
            subtitle: 'Tuesdays • 10:00a',
            status: 'Capacity 94%',
          ),
          AdminSectionDetail(
            title: 'Average visit duration',
            subtitle: '4.6 hours / member',
            status: '+12 mins MoM',
          ),
          AdminSectionDetail(
            title: 'Referral pipeline',
            subtitle: '31 active referrals',
            status: 'Worth \$41k ARR',
          ),
        ],
      },
    );
  }
}
