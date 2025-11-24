# Dependencies

## General rule

- Keep dependencies light and intentional.

If a feature can be implemented clearly in ~10–20 lines of code, it might not be worth pulling in a new dependency.

## AI MUST NOT reimplement

Do NOT reimplement or “roll your own” for:

- Cryptography / security primitives.
- Date/time formatting and timezone handling.
- HTTP clients.
- Firebase / Firestore client or admin wrappers.
- Routing and navigation frameworks.

For these, rely on stable, well-known libraries or first-party SDKs.

## When adding a new dependency

- Ensure it’s actively maintained.
- Prefer widely-used libraries over obscure ones.
- Consider if it fits the project’s architecture and style.