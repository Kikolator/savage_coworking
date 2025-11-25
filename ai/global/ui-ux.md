# UI / UX Principles (Global)

These principles guide all front-end work. Stack-specific docs (e.g. Flutter) may add more detail.

## Core UX Principles

- Prioritize **clarity over decoration**.
- Make the **primary action obvious** on each screen.
- Use a **clear visual hierarchy**:
  - One main title.
  - One main action.
  - Supporting / secondary actions visually de-emphasized.
- Keep screens focused:
  - Avoid cramming unrelated actions into one view.
  - Prefer multiple short steps over one overwhelming form.

## Consistency

- Use a **single design system** per platform:
  - Consistent spacing, radii, shadows, and typography.
  - Consistent component patterns for lists, cards, dialogs, etc.
- Reuse shared components instead of re-implementing similar widgets.

## Accessibility & Usability

- Touch targets should be at least **44x44 dp** (Apple HIG) / 48x48 dp (Material).
- Ensure **readable font sizes** and contrast:
  - Body text should not be tiny.
  - Avoid low-contrast text on backgrounds.
- Don’t rely on color alone to convey meaning (use icons, labels, states).

## Feedback & States

Every async action should have a visible state:

- **Loading**: spinner, progress, or skeleton.
- **Success**: subtle confirmation and updated UI.
- **Error**: clear error message close to the source of the problem.

Never leave the user wondering if something happened.

## Layout

- Use **breathing room**:
  - Horizontal padding (e.g. 16–24 dp).
  - Vertical spacing between sections.
- Avoid fixed pixel-perfect layouts that break on:
  - small screens
  - large monitors

## Motion & Animation

- Use motion to **reinforce meaning**, not just for flair.
- Keep animations:
  - short
  - smooth
  - interruptible (user can still interact / go back)
- Avoid long, blocking animations that slow down interaction.

## Dark Mode & Theming (Optional but Recommended)

- Prefer a theme-based approach where:
  - colors, typography, and shapes come from a central theme.
- If dark mode is supported:
  - ensure sufficient contrast in both light and dark themes.