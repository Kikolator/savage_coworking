import 'package:flutter/material.dart';

/// A reusable skeleton widget for loading states with shimmer effect.
class Skeleton extends StatefulWidget {
  const Skeleton({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
    this.margin,
  });

  final double width;
  final double? height;
  final BorderRadius? borderRadius;
  final EdgeInsets? margin;

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _animation = Tween<double>(begin: -2.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderRadius = widget.borderRadius ?? BorderRadius.circular(8);
    final height = widget.height ?? 20.0;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: height,
          margin: widget.margin,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            gradient: LinearGradient(
              begin: Alignment(_animation.value - 1, 0),
              end: Alignment(_animation.value, 0),
              colors: [
                theme.colorScheme.surfaceContainerHighest,
                theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                theme.colorScheme.surfaceContainerHighest,
              ],
              stops: const [0.0, 0.5, 1.0],
            ),
          ),
        );
      },
    );
  }
}

/// Skeleton for a card-like widget
class SkeletonCard extends StatelessWidget {
  const SkeletonCard({
    super.key,
    this.width,
    this.height = 120,
    this.padding,
  });

  final double? width;
  final double height;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding ?? const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Skeleton(width: double.infinity, height: 16),
          const SizedBox(height: 12),
          Skeleton(width: 120, height: 12),
          const SizedBox(height: 8),
          Skeleton(width: 80, height: 12),
        ],
      ),
    );
  }
}

