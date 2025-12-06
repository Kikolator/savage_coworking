enum AdminDashboardSection {
  overview('Overview'),
  hotDesks('Hot Desks'),
  meetingRooms('Meeting Rooms'),
  finance('Finance'),
  members('Members'),
  analytics('Analytics'),
  subscriptions('Subscriptions');

  const AdminDashboardSection(this.label);

  final String label;
}
