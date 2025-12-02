# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Added
- Shared `deskBookings` schema coverage, Flutter MVVM feature, and Firestore rules that enable members to create, manage, and validate hot desk reservations.
- go_router navigation with a startup splash experience that routes members to authentication or desk booking based on their sign-in state.
- Admin dashboard route with responsive child views and a gated user-menu shortcut that appears only for privileged members.
- Firebase Functions change-log trigger that records every Firestore document mutation into the `changeLogs` collection for auditing.
- Material 3 theme system with forest green primary color, white background, and subtle glass-style card decorations.
- Reusable `GlassCard` widget for consistent glassmorphism effects throughout the app.

### Changed
- Bottom navigation bar now follows Material 3 and Cupertino design guidelines with proper spacing, icon sizing, and accessibility support.
- Bottom navigation bar uses Material 3 on web platforms regardless of underlying OS.

### Changed
- Rewrote `README.md` with project overview, setup, and workflow guidance.

