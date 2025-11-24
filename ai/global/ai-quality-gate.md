# AI Quality Gate

Before finalizing any code or refactor, AI MUST run this checklist.

## Architecture

- Flutter:
  - Does the code follow UI → ViewModel → Service → Repository → Firebase/API?
  - Is there any business logic in widgets? If yes, move it.

- Node:
  - Does the code follow Controller → Service → Repository?
  - Are repositories free from HTTP-specific logic?

## Files & structure

- Are files placed in the correct folder for their role?
- Do file and symbol names follow naming conventions?

## Contracts

- Do models and DTOs match `/shared/schemas/*`?
- Do API handlers adhere to documented contracts?

## Security

- Are user inputs validated before hitting core logic/data?
- Are Firestore/Storage rules updated if new collections/fields were introduced?
- Is any secret accidentally hardcoded?

## Dependencies

- Were any new dependencies added?
  - Are they necessary and justified?
- Are we avoiding reimplementation of forbidden low-level functionality (crypto, etc.)?

## Output completeness

- Are imports included?
- Are code blocks self-contained and compilable where possible?
- Is any “TODO” critical to make it work? If so, call it out clearly.

If any check fails, revise the code before presenting it.