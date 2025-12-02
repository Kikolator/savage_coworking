import 'package:flutter/material.dart';

import '../../../../core/widgets/skeleton.dart';

/// Skeleton loading state for desk grid
class DeskGridSkeleton extends StatelessWidget {
  const DeskGridSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Skeleton(width: 60, height: 16),
                    Skeleton(width: 40, height: 20, borderRadius: BorderRadius.circular(12)),
                  ],
                ),
                const SizedBox(height: 8),
                Skeleton(width: 100, height: 12),
                const SizedBox(height: 4),
                Skeleton(width: 80, height: 12),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Skeleton loading state for booking list
class BookingListSkeleton extends StatelessWidget {
  const BookingListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        3,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Skeleton(width: 100, height: 16),
                      const Spacer(),
                      Skeleton(width: 60, height: 24, borderRadius: BorderRadius.circular(12)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Skeleton(width: 150, height: 12),
                  const SizedBox(height: 8),
                  Skeleton(width: 200, height: 12),
                  const SizedBox(height: 8),
                  Skeleton(width: 80, height: 32, borderRadius: BorderRadius.circular(8)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

