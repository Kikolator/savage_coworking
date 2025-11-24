# Configuration & Secrets

## Secrets

- NEVER hardcode secrets in the repository.
- Use:
  - environment variables
  - Firebase Secrets
  - Remote Config (for non-sensitive, dynamic config)
- CI/CD pipelines must store secrets securely.

## Environment separation

- Use different Firebase projects / environments for:
  - development
  - staging
  - production
- Centralize environment logic in:
  - Node: `src/config/env.ts`
  - Flutter: an environment configuration layer (e.g. using flavors or env files).

## Principles

- Code should be environment-agnostic where possible.
- Configuration belongs in env / config files, not in logic.