# User Schema

This document defines the user model schema used across the application.

## Core User Model

```typescript
interface User {
  id: string;              // Firebase Auth UID
  email: string;           // User's email address
  displayName?: string;    // Optional display name
  photoUrl?: string;       // Optional profile photo URL
  createdAt: Timestamp;   // Account creation timestamp
  updatedAt: Timestamp;   // Last update timestamp
}
```

## Firestore Collection

- **Collection**: `users`
- **Document ID**: Firebase Auth UID

## Field Descriptions

- `id`: Unique identifier from Firebase Authentication
- `email`: User's email address (required, unique)
- `displayName`: Optional display name for the user
- `photoUrl`: Optional URL to user's profile photo
- `createdAt`: Timestamp when the user account was created
- `updatedAt`: Timestamp when the user document was last updated

## Validation Rules

- `email`: Must be a valid email format
- `displayName`: If provided, must be between 1 and 100 characters
- `photoUrl`: If provided, must be a valid URL

## Access Control

See Firestore rules for user document access control.

