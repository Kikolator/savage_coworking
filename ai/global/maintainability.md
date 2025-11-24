# Maintainability

When writing or changing code, ask:

- “Will someone understand this in 6 months?”
- “Is this tightly coupled to something that might change?”
- “Can I swap this implementation later without rewriting everything?”

## Avoid

- God classes / god services.
- Excessive cross-module imports.
- UI tightly coupled to backend responses.
- Copy-paste logic across features.

## Prefer

- Small, composable modules.
- Clear interfaces and contracts.
- Encapsulation of complexity inside well-named components and services.