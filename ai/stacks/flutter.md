# Flutter Stack Rules

These rules apply when working in Flutter/Dart (primarily `lib/` and `test/`).

---

## Architecture

- Use MVVM with feature-based folders.
- Each feature should contain:
  - `view/`
  - `viewmodel/`
  - `service/`
  - `repository/`
  - `models/`

- UI (Views):
  - Displays state and handles user input.
  - No business logic or data access.

- ViewModel:
  - Holds UI state.
  - Calls services only.

- Service:
  - Contains business logic.
  - Calls repositories or external APIs.

- Repository:
  - Encapsulates data sources (Firebase, HTTP APIs, local storage).

See:
- `/ai/patterns/mvvm.md`
- `/ai/examples/flutter/lib/features/auth/*` (reference implementation)

---

## State management & navigation

- State: `flutter_riverpod` + `riverpod_annotation` where appropriate.
- Navigation: `go_router`.

---

## UI / UX & Responsiveness

Also see `/ai/global/ui-ux.md` for general UX principles.

### Breakpoints & Responsive Layout

Use **responsive layouts** with these breakpoints:

- `≥ 769` px: **desktop**
- `768 – 481` px: **tablet**
- `480 – 0` px: **phone**

Pattern per feature:

- A primary view file:
  - `view/<feature>_view.dart`
  - Uses a responsive builder to select the appropriate layout.
- Device-specific view files:
  - `view/<feature>_view.mobile.dart`
  - `view/<feature>_view.tablet.dart`
  - `view/<feature>_view.desktop.dart`

The main `<feature>_view.dart`:

- Contains **only**:
  - layout selection (based on breakpoint)
  - wiring to the ViewModel
- Delegates layout to device-specific view widgets.

Use a responsive layout helper (e.g. `responsive_builder`) or an equivalent internal abstraction to implement these breakpoints consistently across features.
```dart
class ExampleView extends StatelessWidget {
  const ExampleView({super.key});

  @override
  Widget builder(
    BuildContext context,
    Widget? child,
  ) {
    return ScreenTypeLayout.builder(
      mobile: (_) => const ExampleViewMobile(),
      tablet: (_) => const ExampleViewTablet(),
      desktop: (_) => const ExampleViewDesktop(),
    );
  }
}
```

### Platform Awareness (Cupertino vs Material)

Make the UI **platform-aware**:

- On Apple platforms (iOS, macOS):
  - Prefer Cupertino-style components and/or glassmorphism where appropriate.
  - Respect platform navigation patterns (e.g. back gestures, tab bars).
- On Android and Web:
  - Prefer Material widgets with consistent theming.

Implementation rules:

- Detect platform using Flutter’s standard APIs (e.g. `Theme.of(context).platform` or `defaultTargetPlatform`).
- Do NOT fork entire codebases per platform:
  - Use conditional branches to choose the appropriate widget types.
- Keep behavior and flows consistent across platforms; only adjust look and feel.


### Layout & Spacing

- Use consistent padding:
  - e.g. 16–24 logical pixels for main horizontal padding.
- Use `SafeArea` when appropriate to avoid notches/status bars.
- On large screens:
  - Constrain max content width where it improves readability.
  - Prefer multi-column layouts instead of stretching content edge-to-edge.

### Accessibility & Interactions

- Ensure touch targets at least ~44–48 dp.
- Maintain sufficient color contrast (especially with custom themes).
- Provide clear focus / pressed / disabled states.

### Feedback

- For async operations:
  - Show loading indicators or skeletons.
  - Disable or debounce buttons to avoid duplicate calls.
- Display errors close to the source (e.g. under text fields) instead of generic “something went wrong” popups only.

---

## Dependencies

Recommended minimal set:

- State:
  - `flutter_riverpod`, `riverpod_annotation`
- Navigation:
  - `go_router`
- Firebase (when needed):
  - `firebase_core` + only the Firebase packages required for the feature
- Models:
  - `freezed`
  - `json_serializable`
- Utilities (as needed):
  - `url_launcher`
  - `image_picker`
  - `file_picker`
  - `flutter_svg`

Dev dependencies:

- `build_runner`
- `freezed`
- `json_serializable`
- `riverpod_generator`

Keep dependency list minimal and aligned with project conventions.

---

## Assets

- Use a single root `/assets` folder, organized by type:
  - `/assets/images`
  - `/assets/fonts`
  - `/assets/icons`

Configure assets in `pubspec.yaml` in a structured and predictable way.

---

## Performance

- Minimize unnecessary rebuilds:
  - Split large widgets into smaller ones.
  - Use Riverpod selectors where appropriate.
- Cache expensive / stable data where it makes sense.
- Use pagination or lazy-loading for long lists.

---

## Error Handling

- Wrap external calls (Firebase, HTTP clients, platform channels).
- Log errors:
  - Crashlytics / analytics for production.
  - Console logs for debug builds.
- Return structured error/failure types, not plain strings.
- Avoid swallowing errors silently; always surface them to:
  - the UI
  - logs
  - or both.

---

## Comments & Documentation

- Comment only when code is not self-explanatory.
- Document:
  - public APIs
  - complex flows
  - critical design decisions

Prefer up-to-date, concise docs over long, outdated comments.