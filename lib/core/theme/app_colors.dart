import 'package:flutter/material.dart';

/// App color constants for the light theme.
/// Colors are organized to support future dark theme implementation.
class AppColors {
  AppColors._();

  // Primary colors - Forest green theme
  static const Color primaryGreen = Color(0xFF1B4332);
  static const Color primaryGreenLight = Color(0xFF2D5016);
  static const Color primaryGreenDark = Color(0xFF081C15);
  static const Color primaryGreenVariant = Color(0xFF40916C);

  // Background colors
  static const Color backgroundWhite = Color(0xFFFFFFFF);
  static const Color surfaceWhite = Color(0xFFFAFAFA);

  // Text colors
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B6B6B);
  static const Color textTertiary = Color(0xFF9E9E9E);

  // Border and divider colors
  static const Color borderLight = Color(0xFFE0E0E0);
  static const Color borderSubtle = Color(0xFFF0F0F0);
  static const Color divider = Color(0xFFE5E5E5);

  // Glass effect colors (semi-transparent)
  static Color glassBackground = Colors.white.withOpacity(0.75);
  static Color glassBorder = Colors.white.withOpacity(0.3);
  static Color glassOverlay = Colors.white.withOpacity(0.1);

  // Semantic colors
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFF57C00);
  static const Color info = Color(0xFF1976D2);

  // Interactive states
  static const Color hoverOverlay = Color(0x0A000000);
  static const Color pressedOverlay = Color(0x14000000);
  static const Color focusOverlay = Color(0x1A1B4332);
}


