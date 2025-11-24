# savage_ai

A new Flutter project.

## Getting Started

First we check we have our environment set up. We need Flutter and pub, npm, and firebase emulators for debugging.

```bash
# Ensure Flutter is properly installed.
flutter doctor

# Get pub.dev packages.
flutter pub get

# Make sure npm is installed.
npm -v

# Install npm files in functions directory.
cd functions && npm install
```

To run the debug version of the app:
```bash
# Start Firebase emulators
firebase emulators:start

# Run Flutter debug mode.
flutter run --debug
# When prompted choose Google Chrome.
```