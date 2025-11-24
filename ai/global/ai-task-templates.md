# AI Task Templates

These are templates for how AI should handle typical tasks.

---

## New Flutter feature

When asked to create a new Flutter feature:

1. Create a folder:
   - `lib/features/<feature>/`

2. Inside, create:
   - `view/<feature>_view.dart`
   - `viewmodel/<feature>_view_model.dart`
   - `service/<feature>_service.dart`
   - `repository/<feature>_repository.dart`
   - `models/...` (freezed + json_serializable)

3. Wire it with:
   - Riverpod providers.
   - go_router routes.

4. Use:
   - `examples/flutter/lib/features/auth/*` as an example/template.

---

## New Node backend module

When asked to create a new Node module:

1. Create a folder:
   - `src/modules/<feature>/`

2. Inside, create:
   - `<feature>.types.ts`
   - `<feature>.repository.ts`
   - `<feature>.service.ts`
   - `<feature>.controller.ts`
   - `<feature>.validators.ts`
   - `__tests__/<feature>.service.test.ts`

3. Add routes in:
   - `src/api/routes/<feature>Routes.ts`

4. Use:
   - `examples/functions/src/modules/users/*` and `examples/functions/src/api/routes/userRoutes.ts` as examples.

---

## Schema / model change

When asked to add or change a model/field:

1. Update schema:
   - `/shared/schemas/<model>.json` (or equivalent schema file).

2. Update backend:
   - DTO types and validators.
   - Repository logic where necessary.

3. Update frontend:
   - Freezed models.
   - Mappers if applicable.

4. Update docs:
   - `/shared/apis/APIS.md`

5. Ensure Firestore rules are still correct and secure.