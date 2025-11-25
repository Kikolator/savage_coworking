enum AppRoute {
  splash(path: '/', name: 'splash'),
  auth(path: '/auth', name: 'auth'),
  hotDesk(path: '/desk', name: 'hotDesk');

  const AppRoute({
    required this.path,
    required this.name,
  });

  final String path;
  final String name;
}
