# Hard Rules (Non-Negotiable)

These rules MUST NEVER be violated by AI-generated or human-written code.

## Structural boundaries

- Flutter:
  - UI MUST NOT contain business logic or call Firebase/Firestore directly.
  - ViewModels MUST NOT call Firebase/Firestore directly.
  - Repositories MUST NOT manage navigation or UI.

- Node:
  - Controllers MUST NOT call Firestore / DB directly.
  - Services MUST NOT return HTTP response objects.
  - Repositories MUST NOT throw HTTP-specific errors.

## Security

- Never trust client input; always validate.
- Never write Firestore rules that effectively allow public full access (e.g. `allow read, write: if true`).
- Never expose secrets, keys, or tokens in code.
- Never skip authentication/authorization checks where they are expected.

## Dependencies

AI MUST NOT reimplement:

- Cryptography primitives or token signing/verification.
- Core HTTP client behavior.
- Date/time parsing and timezone complexity.
- Firebase SDK or Admin SDK internals.
- Routing frameworks.

## Code generation

When generating models:

- Flutter:
  - Use `freezed` and `json_serializable` for data models.
- Node:
  - Use TypeScript interfaces/types for DTOs and entities.

When in doubt, follow the `/ai` docs strictly instead of improvising new patterns.