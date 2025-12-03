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
- Hot desk management: admins can create, edit, and delete desks through the admin dashboard. Desk management includes validation, active/inactive status toggling, and protection against deletion when desks have active bookings.
- Desk selection in booking flow: users can view and select available desks from a dropdown when creating bookings. Desks can be filtered by workspace ID, and only active desks are shown for selection.
- Enhanced hot desk booking UI/UX:
  - Visual desk selector with card-based grid layout showing availability status
  - Quick date/time presets (Today, Tomorrow, This Week) and duration presets (2h, Half day, Full day)
  - Combined date-time picker widget
  - Grouped bookings list by date (Today, Tomorrow, This Week, Later) with collapsible sections
  - Enhanced empty states with helpful messages and CTAs
  - Skeleton loading states with shimmer animation
  - Quick stats bar showing available desks count
  - Booking confirmation dialog with booking summary
  - Search and filter functionality for desk selection
- Workspace management infrastructure:
  - Workspace schema, model, repository, service, and providers
  - Workspace dropdown in desk creation dialog
  - Firestore rules for workspaces collection
- Desk image upload functionality:
  - Optional image upload when creating desks
  - Firebase Storage integration for desk images
  - Image preview and removal in desk creation dialog
  - Storage service for handling image uploads
- Enhanced desk creation dialog:
  - Workspace dropdown populated from Firestore
  - Active/inactive switch for desk status
  - Optional image picker with preview
  - Improved form validation and error handling

### Changed
- Bottom navigation bar now follows Material 3 and Cupertino design guidelines with proper spacing, icon sizing, and accessibility support.
- Bottom navigation bar uses Material 3 on web platforms regardless of underlying OS.
- Rewrote `README.md` with project overview, setup, and workflow guidance.
- Centralized navigation logic in NavigationService for consistent routing decisions based on authentication and admin status.
- Removed redundant SplashDestination enum, now using AppRoute directly throughout the splash flow.
- Admin users are now routed to admin dashboard on app startup.

### Fixed
- Fixed TypeScript build output path in Firebase Functions, ensuring compiled files are correctly placed in `lib/` directory for emulator and deployment.
- Fixed error handling for Firestore JavaScript objects on web platform, preventing type mismatch errors when booking desks.
- Fixed RangeError when displaying booking confirmation dialog with empty booking ID.
- Fixed scroll behavior in hot desk booking screen by removing nested scroll views and making entire page scrollable.

