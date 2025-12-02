# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Added
- User document creation in Firestore after successful signup, with User model and UserRepository following the shared schema.
- Shared `deskBookings` schema coverage, Flutter MVVM feature, and Firestore rules that enable members to create, manage, and validate hot desk reservations.
- go_router navigation with a startup splash experience that routes members to authentication or desk booking based on their sign-in state.
- Admin dashboard route with responsive child views and a gated user-menu shortcut that appears only for privileged members.
- Firebase Functions change-log trigger that records every Firestore document mutation into the `changeLogs` collection for auditing.
- Material 3 theme system with forest green primary color, white background, and subtle glass-style card decorations.
- Reusable `GlassCard` widget for consistent glassmorphism effects throughout the app.
- NavigationService for centralized app routing decisions based on user authentication and admin privileges.
- Bidirectional navigation between admin and user dashboards:
  - Admin dashboard menu includes "User Dashboard" option to switch back to user view.
  - User dashboard menu includes "Admin Dashboard" option for admin users.

### Changed
- Bottom navigation bar now follows Material 3 and Cupertino design guidelines with proper spacing, icon sizing, and accessibility support.
- Bottom navigation bar uses Material 3 on web platforms regardless of underlying OS.
- Rewrote `README.md` with project overview, setup, and workflow guidance.
- Centralized navigation logic in NavigationService for consistent routing decisions based on authentication and admin status.
- Removed redundant SplashDestination enum, now using AppRoute directly throughout the splash flow.
- Admin users are now routed to admin dashboard on app startup.

### Fixed
- Fixed TypeScript build output path in Firebase Functions, ensuring compiled files are correctly placed in `lib/` directory for emulator and deployment.

