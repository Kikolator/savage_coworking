# MVVM Pattern

This document defines how MVVM is used across the project.

## Core roles

- **View (UI)**:
  - Widgets/screens in Flutter.
  - Responsible for rendering state and handling user interaction.
  - Can call ViewModel methods but not services or repositories directly.

- **ViewModel**:
  - Holds UI state.
  - Orchestrates calls to services.
  - Exposes state as immutable objects/streams.

- **Service**:
  - Contains business logic and use cases.
  - Talks to repositories, not UI.

- **Repository**:
  - Encapsulates data access:
    - APIs
    - Firebase Auth
    - Firestore
    - Storage
    - Local cache

## Data flow summary

```text
User action → View
  → calls ViewModel
  → calls Service
  → calls Repository
  → data source (Firebase/API)
  → back up through Repository → Service → ViewModel → View
  ```

## Principles
- Single source of truth for UI state in ViewModels.
- No business logic in Views.
- No data access in ViewModels.
- Services and repositories are reusable and testable independently of UI.