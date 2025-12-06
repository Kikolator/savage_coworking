import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/admin_dashboard_data.dart';
import '../models/admin_dashboard_section.dart';
import '../../subscription/models/subscription_status.dart';

class AdminDashboardRepository {
  AdminDashboardRepository(this._firestore);

  final FirebaseFirestore _firestore;

  Future<AdminDashboardData> fetchDashboardSnapshot({
    String? workspaceId,
  }) async {
    final now = DateTime.now().toUtc();
    final weekAgo = now.subtract(const Duration(days: 7));
    final monthStart = DateTime(now.year, now.month, 1).toUtc();

    // Fetch data in parallel
    final results = await Future.wait([
      _fetchDeskBookings(workspaceId, now, weekAgo),
      _fetchSubscriptions(now, monthStart),
      _fetchUsers(),
    ]);

    final deskBookings = results[0] as List<Map<String, dynamic>>;
    final subscriptions = results[1] as List<Map<String, dynamic>>;
    final userCount = results[2] as int;

    // Calculate metrics
    final summaryCards = _calculateSummaryCards(
      deskBookings: deskBookings,
      subscriptions: subscriptions,
      userCount: userCount,
      now: now,
      weekAgo: weekAgo,
    );

    final sectionDetails = _calculateSectionDetails(
      deskBookings: deskBookings,
      subscriptions: subscriptions,
      workspaceId: workspaceId,
      now: now,
    );

    return AdminDashboardData(
      summaryCards: summaryCards,
      sectionDetails: sectionDetails,
    );
  }

  Future<List<Map<String, dynamic>>> _fetchDeskBookings(
    String? workspaceId,
    DateTime now,
    DateTime weekAgo,
  ) async {
    Query<Map<String, dynamic>> query = _firestore
        .collection('deskBookings')
        .where('startAt', isGreaterThanOrEqualTo: Timestamp.fromDate(weekAgo))
        .where('startAt', isLessThanOrEqualTo: Timestamp.fromDate(now));

    if (workspaceId != null) {
      query = query.where('workspaceId', isEqualTo: workspaceId);
    }

    final snapshot = await query.get();
    final results = <Map<String, dynamic>>[];
    for (final doc in snapshot.docs) {
      final data = doc.data();
      results.add({
        'id': doc.id,
        ...data,
      });
    }
    return results;
  }

  Future<List<Map<String, dynamic>>> _fetchSubscriptions(
    DateTime now,
    DateTime monthStart,
  ) async {
    final snapshot = await _firestore
        .collection('subscriptions')
        .where('status', isEqualTo: SubscriptionStatus.active.name)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'id': doc.id,
        ...data,
      };
    }).toList();
  }

  Future<int> _fetchUsers() async {
    final snapshot = await _firestore.collection('users').get();
    return snapshot.docs.length;
  }


  List<AdminSummaryCardData> _calculateSummaryCards({
    required List<Map<String, dynamic>> deskBookings,
    required List<Map<String, dynamic>> subscriptions,
    required int userCount,
    required DateTime now,
    required DateTime weekAgo,
  }) {
    // Calculate hot desk occupancy
    final activeBookings = deskBookings.where((b) {
      final status = b['status'] as String?;
      return status == 'confirmed' || status == 'checkedIn';
    }).length;

    final totalDesks = 30; // TODO: Fetch from desks collection
    final occupancy = totalDesks > 0 ? (activeBookings / totalDesks * 100) : 0.0;
    final lastWeekBookings = deskBookings
        .where((b) {
          final startAt = b['startAt'] as Timestamp?;
          if (startAt == null) return false;
          final bookingDate = startAt.toDate();
          return bookingDate.isBefore(weekAgo.add(const Duration(days: 7))) &&
              bookingDate.isAfter(weekAgo);
        })
        .length;
    final lastWeekOccupancy =
        totalDesks > 0 ? (lastWeekBookings / totalDesks * 100) : 0.0;
    final occupancyDelta = occupancy - lastWeekOccupancy;

    // Calculate meeting room utilization (placeholder)
    final meetingRoomUtilization = 68.0;
    final lastWeekMeetingRoomUtil = 71.4;
    final meetingRoomDelta = meetingRoomUtilization - lastWeekMeetingRoomUtil;

    // Calculate MRR from active subscriptions
    double mrr = 0.0;
    for (final subscription in subscriptions) {
      final planId = subscription['planId'] as String?;
      if (planId != null) {
        // TODO: Fetch plan price from subscriptionPlans collection
        // For now, use placeholder
        mrr += 50.0; // Average subscription value
      }
    }
    final mrrFormatted = _formatCurrency(mrr);
    final forecastMrr = mrr * 1.041; // Placeholder forecast
    final mrrDelta = ((mrr - forecastMrr) / forecastMrr * 100);

    return [
      AdminSummaryCardData(
        title: 'Hot desk occupancy',
        value: '${occupancy.toStringAsFixed(0)}%',
        trendLabel: 'vs last week',
        trendDelta: occupancyDelta,
      ),
      AdminSummaryCardData(
        title: 'Meeting room utilization',
        value: '${meetingRoomUtilization.toStringAsFixed(0)}%',
        trendLabel: 'vs last week',
        trendDelta: meetingRoomDelta,
      ),
      AdminSummaryCardData(
        title: 'Monthly recurring revenue',
        value: mrrFormatted,
        trendLabel: 'vs forecast',
        trendDelta: mrrDelta,
      ),
      AdminSummaryCardData(
        title: 'Active members',
        value: userCount.toString(),
        trendLabel: 'since Friday',
        trendDelta: 2.0, // Placeholder
      ),
    ];
  }

  Map<AdminDashboardSection, List<AdminSectionDetail>>
      _calculateSectionDetails({
    required List<Map<String, dynamic>> deskBookings,
    required List<Map<String, dynamic>> subscriptions,
    String? workspaceId,
    required DateTime now,
  }) {
    final details = <AdminDashboardSection, List<AdminSectionDetail>>{};

    // Hot Desks section
    final hotDeskDetails = _calculateHotDeskDetails(
      deskBookings: deskBookings,
      workspaceId: workspaceId,
      now: now,
    );
    details[AdminDashboardSection.hotDesks] = hotDeskDetails;

    // Meeting Rooms section (placeholder)
    details[AdminDashboardSection.meetingRooms] = const [
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
    ];

    // Finance section
    final financeDetails = _calculateFinanceDetails(
      subscriptions: subscriptions,
      now: now,
    );
    details[AdminDashboardSection.finance] = financeDetails;

    // Members section
    final memberDetails = _calculateMemberDetails(subscriptions: subscriptions);
    details[AdminDashboardSection.members] = memberDetails;

    // Analytics section (placeholder)
    details[AdminDashboardSection.analytics] = const [
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
    ];

    return details;
  }

  List<AdminSectionDetail> _calculateHotDeskDetails({
    required List<Map<String, dynamic>> deskBookings,
    String? workspaceId,
    required DateTime now,
  }) {
    // Group bookings by workspace
    final bookingsByWorkspace = <String, List<Map<String, dynamic>>>{};
    for (final booking in deskBookings) {
      final wsId = booking['workspaceId'] as String? ?? 'unknown';
      bookingsByWorkspace.putIfAbsent(wsId, () => []).add(booking);
    }

    final details = <AdminSectionDetail>[];

    // TODO: Fetch actual workspace and desk data
    // For now, create placeholder details
    if (bookingsByWorkspace.isNotEmpty) {
      int workspaceIndex = 0;
      for (final entry in bookingsByWorkspace.entries) {
        final activeBookings = entry.value
            .where((b) {
              final status = b['status'] as String?;
              return status == 'confirmed' || status == 'checkedIn';
            })
            .length;
        final totalDesks = 30; // Placeholder
        final occupancy = totalDesks > 0
            ? (activeBookings / totalDesks * 100).toStringAsFixed(0)
            : '0';

        details.add(AdminSectionDetail(
          title: 'Workspace ${String.fromCharCode(65 + workspaceIndex)}',
          subtitle: '$activeBookings of $totalDesks desks booked today',
          status: '$occupancy% occupancy',
          trailing: workspaceIndex == 0 ? '+5% WoW' : '-3% WoW',
        ));
        workspaceIndex++;
      }
    }

    // Add waitlist placeholder
    details.add(const AdminSectionDetail(
      title: 'Waitlist',
      subtitle: '12 members waiting for recurring spots',
      status: 'Needs review',
    ));

    return details;
  }

  List<AdminSectionDetail> _calculateFinanceDetails({
    required List<Map<String, dynamic>> subscriptions,
    required DateTime now,
  }) {
    // Calculate MRR
    double mrr = 0.0;
    // TODO: Fetch actual plan prices from subscriptionPlans collection
    // For now, use placeholder value per subscription
    mrr = subscriptions.length * 50.0;
    final mrrFormatted = _formatCurrency(mrr);
    final forecastMrr = mrr * 1.041;
    final mrrDelta = ((mrr - forecastMrr) / forecastMrr * 100);

    return [
      AdminSectionDetail(
        title: 'MRR',
        subtitle: '$mrrFormatted current month',
        status: '${mrrDelta >= 0 ? '+' : ''}${mrrDelta.toStringAsFixed(1)}% vs forecast',
        trailing: _formatCurrency(mrr - forecastMrr),
      ),
      const AdminSectionDetail(
        title: 'Outstanding invoices',
        subtitle: '9 invoices past due',
        status: 'Follow-ups needed',
      ),
      const AdminSectionDetail(
        title: 'Upcoming renewals',
        subtitle: '24 contracts expiring within 30 days',
        status: 'Prepare offers',
      ),
    ];
  }

  List<AdminSectionDetail> _calculateMemberDetails({
    required List<Map<String, dynamic>> subscriptions,
  }) {
    // Count new subscriptions this week
    final weekAgo = DateTime.now().toUtc().subtract(const Duration(days: 7));
    final newSubscriptions = subscriptions.where((sub) {
      final createdAt = sub['createdAt'] as Timestamp?;
      if (createdAt == null) return false;
      return createdAt.toDate().isAfter(weekAgo);
    }).length;

    return [
      AdminSectionDetail(
        title: 'New members',
        subtitle: '$newSubscriptions onboarded this week',
        status: '+3 enterprise teams',
      ),
      const AdminSectionDetail(
        title: 'Churn risk',
        subtitle: '7 members flagged',
        status: 'Requires outreach',
      ),
      const AdminSectionDetail(
        title: 'NPS',
        subtitle: 'Score 56 (last 30 days)',
        status: 'Stable',
      ),
    ];
  }

  String _formatCurrency(double amount) {
    if (amount >= 1000) {
      return '\$${(amount / 1000).toStringAsFixed(1)}k';
    }
    return '\$${amount.toStringAsFixed(0)}';
  }
}

