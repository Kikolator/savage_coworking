# Version Control

These rules define how work should be organized in Git.

## Branching model

- Use a **feature-branch workflow**.
- New work MUST be done on a branch, not directly on `main`.

Recommended naming:

- Features: `feature/<short-kebab-description>`
  - e.g. `feature/auth-login-screen`
- Bugfixes: `bugfix/<short-kebab-description>`
  - e.g. `bugfix/fix-auth-token-refresh`
- Hotfixes: `hotfix/<short-kebab-description>`

`main` (or `master`) should always be:
- clean
- deployable / releasable

## Commits

- Commit **regularly** in small, coherent steps.
- Each commit should represent **one logical change**.
- Never commit broken or un-compilable code (unless explicitly in a WIP branch).

Commit message format:

- `feat(scope): description`
- `fix(scope): description`
- `refactor(scope): description`
- `chore(scope): description`
- `docs(scope): description`
- `test(scope): description`

Examples:

- `feat(auth): add login persistence`
- `fix(ui): correct padding in login screen`
- `refactor(app): extract firebase service`

## Pull Requests / Merge Requests

- Prefer **small PRs** over giant ones.
  - Easier to review.
  - Easier to roll back.
  - Lower risk.
- A PR should:
  - Address a focused set of changes.
  - Reference the feature/bug it resolves.
  - Have a short summary and, if needed, a checklist.

## AI-specific behavior

When the AI proposes or describes workflows, it SHOULD:

- Assume work happens on a **feature branch**.
- Suggest **logical commit boundaries** when relevant.
- Prefer **small, incremental PRs**.
- Avoid mixing unrelated changes in the same branch / PR.