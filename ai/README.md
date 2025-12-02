# AI Development Guidelines

If you are an AI assistant (Cursor, ChatGPT, etc.) working in this repository, this folder defines how you MUST behave.

## 1. Read these first

Always load and follow:

- `/ai/global/ai-hard-rules.md`
- `/ai/global/ai-quality-gate.md`
- `/ai/global/naming.md`
- `/ai/global/coding-style.md`

These apply to ALL code in this repo.

## 2. Stack-specific rules

### Flutter / Dart

When editing Flutter code (usually under `lib/` and `test/`):

- `/ai/stacks/flutter.md`
- `/ai/patterns/mvvm.md`
- `/ai/global/architecture-boundaries.md`
- Example feature to copy:
  - `/ai/examples/flutter/lib/features/auth/*`

### Node.js backend

When editing backend code (e.g. `src/`, `functions/src/`, `src/modules/`, `src/api/`):

- `/ai/stacks/node.md`
- `/ai/global/api-contracts.md`
- `/ai/global/architecture-boundaries.md`
- Example module to copy:
  - `/ai/examples/functions/src/modules/users/*`
  - `/ai/examples/functions/src/api/routes/userRoutes.ts`

## 3. Shared project rules

For anything related to:

- schemas
- database
- Firestore/Storage rules
- shared types
- API docs

Use:

- `/ai/project/shared-project.md`
- `/shared/schemas/*`
- `/shared/apis/APIS.md`

These define the **single source of truth** for models and contracts.

## 4. Philosophy

- Keep it simple.
- Prefer readability over “cleverness”.
- Small, single-responsibility functions and modules.
- Avoid deep nesting / “pyramids of doom”.
- Use minimal dependencies — but never reimplement complex low-level stuff (crypto, date parsing, etc.).
- Design for future-you and other developers:
  - clear boundaries
  - clear naming
  - clear architecture

## 5. Quality gate

Before finalizing any code, run through:

- `/ai/global/ai-quality-gate.md`

Do **not** suggest or apply code that breaks:

- architecture boundaries
- hard rules
- naming conventions
- schema/API contracts

This `/ai` folder is the **law of the project**. Generic “best practices” must never override these rules.

## 6. Project Workflow & History

For version control and release history, follow:

- `/ai/global/version-control.md`
- `/ai/global/changelog.md`

Key expectations:

- New work happens on a **feature branch**, not directly on `main`.
- Commits are **small and logical**, with clear messages.
- Prefer **small PRs** over giant ones.
- `CHANGELOG.md` at the repo root documents notable changes:
  - Use an `[Unreleased]` section for upcoming changes.
  - Add entries under `Added / Changed / Fixed / Removed / Security` as appropriate.

When the AI plans or summarizes work, it should assume:
- a feature-branch workflow
- incremental commits
- updates to `CHANGELOG.md` for user-facing changes.

## 7. UI / UX Principles

For all front-end work, follow the UI/UX foundations defined in:

- `/ai/global/ui-ux.md`
- `/ai/stacks/flutter.md` (Flutter-specific UI rules)

Key principles the AI must follow:

- Use **responsive layouts** based on the project breakpoints  
  (desktop ≥769, tablet 768–481, mobile ≤480).
- Use a **single feature view** that delegates to device-specific views  
  (`view.mobile.dart`, `view.tablet.dart`, `view.desktop.dart`).
- Make UI **platform-aware**:
  - Cupertino/glass style on Apple platforms
  - Material on Android & Web.
- Maintain **clear visual hierarchy**, readable typography, and consistent spacing.
- Ensure accessible touch targets, strong contrast, meaningful feedback states.
- Keep screens focused on one main purpose and avoid UI clutter.

These principles apply to all new views, components, and UI refactors.