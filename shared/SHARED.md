# Shared

Centralized contracts and rules that every client and backend must follow.

## Schemas

- `user.schema.md` — canonical user record with membership summary.
- `subscription-plan.schema.md` — subscription plan models with nested billing, quota, pricing, and external integration.
- `subscription.schema.md` — recurring subscription models with effective quota and display information.
- `pass-bundle.schema.md` — one-time pass bundle models for daypass purchases.
- `usage.schema.md` — usage tracking models for subscriptions and pass bundles.
- `booking.schema.md` — desk and meeting room booking models with subscription/passBundle source tracking.
- `hot_desk_booking.schema.md` — legacy hot desk booking schema (deprecated in favor of `booking.schema.md`).

Add or update schema documents here before making app or backend changes.