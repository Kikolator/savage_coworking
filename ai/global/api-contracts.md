# API Contracts

API payload shapes MUST match the shared schemas.

## Source of truth

- `/shared/schemas/*` — model definitions.
- `/shared/apis/APIS.md` — human-readable API documentation.

## Rules

1. All request and response payload shapes must be defined:
   - In schemas, and
   - In API docs where applicable.

2. Flutter:
   - Uses freezed + json_serializable to generate models from the defined contract.
   - Must not add fields not present in schemas.

3. Node:
   - Uses TypeScript interfaces/types to represent DTOs.
   - Must validate input against these shapes.

4. When changing a payload:
   - Update schemas.
   - Update validators.
   - Update docs.
   - Update Flutter models and Node types.

## Example

UserCreateRequest:

```json
{
  "email": "string",
  "name": "string"
}
```

UserResponse:
```json
{
  "id": "string",
  "email": "string",
  "name": "string",
  "createdAt": "timestamp"
}
```