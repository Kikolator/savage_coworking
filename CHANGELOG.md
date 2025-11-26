# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]

### Added
- Shared `deskBookings` schema coverage, Flutter MVVM feature, and Firestore rules that enable members to create, manage, and validate hot desk reservations.
- go_router navigation with a startup splash experience that routes members to authentication or desk booking based on their sign-in state.
- Firebase Functions change-log trigger that records every Firestore document mutation into the `changeLogs` collection for auditing.

### Changed
- Rewrote `README.md` with project overview, setup, and workflow guidance.

