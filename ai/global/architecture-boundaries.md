# Architecture Boundaries

These boundaries MUST NOT be broken.

---

## Flutter Architecture Flow (MVVM)

```text
UI (Widgets)
  ↓ reads / triggers
ViewModel (State controller)
  ↓ calls
Service (Business logic)
  ↓ calls
Repository (Data access)
  ↓ calls
Firebase / APIs / DB
```

## Forbidden
❌ UI → Repository  
❌ UI → Firebase  
❌ ViewModel → Firestore directly  
❌ Service → UI components  
❌ Repository → Navigation  

---

# Node.js Architecture Flow
```text
HTTP / Events
↓
Controller (I/O layer)
↓
Service (Logic)
↓
Repository (Data layer)
↓
Firebase Admin / Database / External APIs
```

## Forbidden
❌ Controller accessing Firestore / DB directly.
❌ Service returning HTTP responses (res.next) instead of plain data/errors.
❌ Repository throwing HTTP-specific errors (status codes).
❌ Shared utilities importing controllers or services.

---

# Shared Schemas as Source of Truth
- /shared/schemas/* define models.
- ALL models in Flutter and Node MUST match these schemas.
- Do not drift on field names or types.