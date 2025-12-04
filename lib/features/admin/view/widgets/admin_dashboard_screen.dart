import 'package:flutter/material.dart';

import '../../models/admin_dashboard_section.dart';
import '../admin_dashboard_view.dart';
import 'sections/admin_analytics_section.dart';
import 'sections/admin_desk_management_section.dart';
import 'sections/admin_finance_section.dart';
import 'sections/admin_meeting_rooms_section.dart';
import 'sections/admin_members_section.dart';
import 'sections/admin_overview_section.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({
    super.key,
    required this.props,
    required this.contentPadding,
    required this.maxContentWidth,
    required this.useNavigationRail,
    required this.showBottomNav,
  });

  final AdminDashboardViewProps props;
  final EdgeInsets contentPadding;
  final double? maxContentWidth;
  final bool useNavigationRail;
  final bool showBottomNav;

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.props.state;
    final selectedIndex = AdminDashboardSection.values.indexOf(
      state.selectedSection,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin dashboard'),
        actions: [
          IconButton(
            tooltip: 'Refresh data',
            onPressed: widget.props.onRefresh,
            icon: const Icon(Icons.refresh),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Builder(builder: widget.props.userMenuBuilder),
          ),
        ],
      ),
      bottomNavigationBar: widget.showBottomNav
          ? NavigationBar(
              selectedIndex: selectedIndex,
              onDestinationSelected: (index) => widget.props.onSectionSelected(
                AdminDashboardSection.values[index],
              ),
              destinations: AdminDashboardSection.values
                  .map(
                    (section) => NavigationDestination(
                      icon: Icon(_iconForSection(section)),
                      label: section.label,
                    ),
                  )
                  .toList(),
            )
          : null,
      body: SafeArea(
        child: Column(
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: state.isLoading
                  ? const LinearProgressIndicator()
                  : const SizedBox.shrink(),
            ),
            Expanded(
              child: widget.useNavigationRail
                  ? Row(
                      children: [
                        NavigationRail(
                          selectedIndex: selectedIndex,
                          onDestinationSelected: (index) =>
                              widget.props.onSectionSelected(
                                AdminDashboardSection.values[index],
                              ),
                          labelType: NavigationRailLabelType.all,
                          destinations: AdminDashboardSection.values
                              .map(
                                (section) => NavigationRailDestination(
                                  icon: Icon(_iconForSection(section)),
                                  label: Text(section.label),
                                ),
                              )
                              .toList(),
                        ),
                        Expanded(child: _buildContent(context)),
                      ],
                    )
                  : _buildContent(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final child = _buildSectionContent(context);
    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        padding: widget.contentPadding,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: widget.maxContentWidth ?? double.infinity,
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: child,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionContent(BuildContext context) {
    final state = widget.props.state;
    final data = state.data;
    final error = state.errorMessage;

    if (error != null) {
      return _ErrorState(message: error, onRetry: widget.props.onRefresh);
    }

    if (data == null) {
      return state.isLoading
          ? const _LoadingState()
          : const _EmptyState(message: 'No admin data available yet.');
    }

    switch (state.selectedSection) {
      case AdminDashboardSection.overview:
        return AdminOverviewSection(
          data: data,
          onNavigateToSection: widget.props.onSectionSelected,
        );
      case AdminDashboardSection.hotDesks:
        return const AdminDeskManagementSection();
      case AdminDashboardSection.meetingRooms:
        return AdminMeetingRoomsSection(
          details: data.detailsFor(AdminDashboardSection.meetingRooms),
        );
      case AdminDashboardSection.finance:
        return AdminFinanceSection(
          details: data.detailsFor(AdminDashboardSection.finance),
        );
      case AdminDashboardSection.members:
        return AdminMembersSection(
          details: data.detailsFor(AdminDashboardSection.members),
        );
      case AdminDashboardSection.analytics:
        return AdminAnalyticsSection(
          details: data.detailsFor(AdminDashboardSection.analytics),
        );
    }
  }

  IconData _iconForSection(AdminDashboardSection section) {
    switch (section) {
      case AdminDashboardSection.overview:
        return Icons.dashboard_outlined;
      case AdminDashboardSection.hotDesks:
        return Icons.chair_alt_outlined;
      case AdminDashboardSection.meetingRooms:
        return Icons.meeting_room_outlined;
      case AdminDashboardSection.finance:
        return Icons.payments_outlined;
      case AdminDashboardSection.members:
        return Icons.group_outlined;
      case AdminDashboardSection.analytics:
        return Icons.show_chart_outlined;
    }
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 80),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 64),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 64),
      child: Column(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: 48,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          FilledButton(onPressed: onRetry, child: const Text('Try again')),
        ],
      ),
    );
  }
}
