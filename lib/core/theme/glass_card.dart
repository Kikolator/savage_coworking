import 'dart:ui';
import 'package:flutter/material.dart';
import 'app_colors.dart';

/// A reusable glass-style card widget with subtle blur and transparency.
///
/// This widget creates a card with a glassmorphism effect:
/// - Semi-transparent background
/// - Subtle backdrop blur
/// - Soft border
/// - Minimal shadow
///
/// Example usage:
/// ```dart
/// GlassCard(
///   child: Text('Content here'),
/// )
/// ```
class GlassCard extends StatelessWidget {
  /// The child widget to display inside the card.
  final Widget child;

  /// Optional padding around the child.
  final EdgeInsetsGeometry? padding;

  /// Optional margin around the card.
  final EdgeInsetsGeometry? margin;

  /// Border radius for the card corners.
  final double borderRadius;

  /// Optional width constraint.
  final double? width;

  /// Optional height constraint.
  final double? height;

  /// Optional onTap callback to make the card tappable.
  final VoidCallback? onTap;

  /// Blur sigma value for the backdrop filter.
  /// Lower values create more subtle blur effects.
  final double blurSigma;

  /// Background opacity for the glass effect.
  /// Higher values make the card more opaque.
  final double backgroundOpacity;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = 16,
    this.width,
    this.height,
    this.onTap,
    this.blurSigma = 5.0,
    this.backgroundOpacity = 0.75,
  });

  @override
  Widget build(BuildContext context) {
    final cardContent = Container(
      width: width,
      height: height,
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(backgroundOpacity),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: AppColors.glassBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(16),
            child: child,
          ),
        ),
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: cardContent,
      );
    }

    return cardContent;
  }
}
