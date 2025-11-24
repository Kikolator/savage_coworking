# CHANGELOG Guidelines

This project should maintain a `CHANGELOG.md` at the repository root.

## Purpose

The changelog is a human-readable log of **notable changes** between versions:

- New features
- Changes
- Fixes
- Removals
- Security-related updates

It helps developers, QA, and stakeholders understand **what changed when**.

## Format

Follow a simplified **Keep a Changelog** style with Semantic Versioning.

Recommended structure for `CHANGELOG.md`:

```md
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added
- ...

### Changed
- ...

### Fixed
- ...

### Removed
- ...

### Security
- ...

## [1.0.0] - 2025-01-01

### Added
- Initial release.
```

Sections you can use:
- ### Added — new features.
- ### Changed — behavior changes.
- ### Fixed — bug fixes.
- ### Removed — deprecated features removed.
- ### Security — security-impacting changes.

Not all sections are required for each version; omit empty ones.

## Versioning

Use **Semantic Versioning**:
- MAJOR.MINOR.PATCH
- Bump:
- MAJOR: breaking changes.
- MINOR: new functionality, backward-compatible.
- PATCH: bug fixes / small improvements.

## AI-specific behavior

When the AI implements or describes changes that are user-visible or behavior-changing, it SHOULD:
1. Add or suggest an entry under the ## [Unreleased] section in CHANGELOG.md.
2. Use the appropriate subsection (Added, Changed, Fixed, etc.).
3. Keep changelog entries:
    - short
	- clear
	- high-level (do not dump commit-level details).

Examples:
- For a new feature:
	- Added new login screen with email/password authentication.
- For a bug fix:
	- Fixed incorrect error message when login fails due to network issues.