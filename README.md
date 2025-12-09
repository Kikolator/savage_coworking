# Savage Coworking

Flutter + Firebase workspace experience for booking hot desks, handling auth, and orchestrating automation with Cloud Functions.

## Overview
- Flutter 3 / Dart 3 app that targets web, mobile, and desktop using MVVM + Riverpod.
- Firebase Auth and Cloud Firestore power identity and hot desk lifecycle data.
- Firebase Cloud Functions (TypeScript / Node 24) provide backend automation.
- Shared contracts live in `/shared` and AI contributor guidelines live in `/ai`.

## Notes from Kikolator
This project is created in the first place to manage our coworking space. By making it open source we hope to help other boutique coworking owners make life a little bit easier.

## Requirements
- Flutter SDK ≥ 3.10 (`flutter doctor` should pass for your target platforms)
- Node.js 24.x with npm
- Firebase CLI (`npm install -g firebase-tools`)
- Optional: Android Studio, Xcode, Chrome, or compatible simulators/emulators

## Setup
```bash
# 1. Install Flutter packages
flutter pub get

# 2. Generate freezed/json model code
dart run build_runner build --delete-conflicting-outputs

# 3. From the functions directory, install Cloud Functions dependencies
cd functions
npm install

# 4. and build Cloud Functions
npm run build
```

If you point the app at a new Firebase project, regenerate `lib/firebase_options.dart` with `flutterfire configure`.

## Local Development
```bash
# Start Firebase emulators (auth, firestore, functions, hosting as configured)
firebase emulators:start

# Run Flutter (pick your target device or browser)
flutter run --debug

# Develop functions against the emulator suite
cd functions && npm run serve
```

## Building for Deployment

The app supports two environments: `dev` and `prod`. The environment determines which Firebase project configuration is used.

### Build Modes vs Environments

- **Build Mode** (`--debug` or `--release`): Controls optimization level and debug features
  - Debug: Unoptimized, includes debug tools, connects to emulators
  - Release: Optimized, production-ready code

- **Environment** (`--dart-define=ENV=dev|prod`): Controls which Firebase project to use
  - Dev: Uses `firebase_options_dev.dart` (dev Firebase project)
  - Prod: Uses `firebase_options.dart` (prod Firebase project)

### Build Commands

```bash
# Build for dev environment (release mode with dev Firebase config)
flutter build web --release --dart-define=ENV=dev

# Build for prod environment (release mode with prod Firebase config)
flutter build web --release --dart-define=ENV=prod

# Debug builds default to dev environment (no --dart-define needed)
flutter run --debug  # Uses dev Firebase config automatically
```

### Default Behavior

- **Debug builds**: Automatically use `dev` environment (connects to emulators)
- **Release builds**: Automatically use `prod` environment (unless overridden with `--dart-define=ENV=dev`)

This allows you to:
- Test production-optimized builds with dev Firebase config
- Deploy release builds to dev/staging environments
- Keep debug builds simple (no need to specify environment)

Helpful scripts:
- `flutter test` – widget/unit tests
- `flutter analyze` – static analysis
- `npm run lint` – TypeScript linting for functions
- `npm run build` – transpile Cloud Functions TypeScript

## Project Structure
```
lib/
  app/            # global app wiring (router, theme)
  core/           # config, converters, utilities
  features/
    auth/         # auth models, providers, views
    hot_desk_booking/  # booking domain (models, services, UI)
    splash/       # splash routing logic
functions/        # Firebase Cloud Functions (TypeScript)
shared/           # schemas, database, API, and rules contracts
ai/               # mandatory AI contributor guidelines
```

## Conventions & Docs
- Follow `/ai/README.md` plus the hard rules, naming, and quality gate inside `/ai/global`.
- Keep user-facing changes documented under `## [Unreleased]` in `CHANGELOG.md`.
- Shared schemas under `/shared/schemas` are the single source of truth for models.

## Support
If something feels off:
1. Re-run `flutter pub get` and `dart run build_runner build`.
2. Reset Firebase emulators with `firebase emulators:start --only firestore,auth,functions`.
3. Check the AI docs in `/ai` for workflow expectations or raise an issue in your feature branch.