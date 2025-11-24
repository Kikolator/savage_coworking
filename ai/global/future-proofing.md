# Future-Proofing

Design code so it can evolve.

## Structural patterns

- Modular folder structure.
- Reusable components and utilities.
- Abstractions for external services (APIs, storage, etc.).

## Configuration

- Environment configs for per-env behavior.
- Feature flags for gradual rollouts or experimental features.

## Interfaces & boundaries

- Clear interfaces between:
  - UI and ViewModels (Flutter)
  - Controllers, Services, and Repositories (Node)
- Adaptors / repositories for external systems to avoid lock-in.

The goal is to be able to replace *how* something is implemented without changing *what* it does.