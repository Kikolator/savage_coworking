#!/usr/bin/env bash
set -e

echo "🔧 Project setup starting..."

# 1. Flutter app setup
if [ -d "flutter_app" ]; then
  echo "➡️  Setting up Flutter app..."
  cd flutter_app
  flutter pub get
  cd ..
fi

# 2. Node backend setup (functions or src)
if [ -d "functions" ]; then
  echo "➡️  Installing Node dependencies in functions/..."
  cd functions
  npm install
  cd ..
fi

echo "✅ Setup complete."