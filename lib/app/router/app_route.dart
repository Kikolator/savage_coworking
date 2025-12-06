enum AppRoute {
  splash(path: '/', name: 'splash'),
  auth(path: '/auth', name: 'auth'),
  admin(path: '/admin', name: 'admin'),
  dashboard(path: '/dashboard', name: 'dashboard'),
  home(path: '/home', name: 'home'),
  hotDesk(path: '/desk', name: 'hotDesk'),
  bookings(path: '/bookings', name: 'bookings'),
  subscriptions(path: '/subscriptions', name: 'subscriptions'),
  billing(path: '/billing', name: 'billing'),
  settings(path: '/settings', name: 'settings');

  const AppRoute({required this.path, required this.name});

  final String path;
  final String name;
}
