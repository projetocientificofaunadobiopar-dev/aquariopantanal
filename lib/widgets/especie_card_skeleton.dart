import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class EspecieCardSkeleton extends StatelessWidget {
  const EspecieCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final base = scheme.surfaceContainerHighest;
    final highlight = scheme.surface;

    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: Material(
        elevation: 1,
        color: scheme.surface,
        child: Shimmer.fromColors(
          baseColor: base,
          highlightColor: highlight,
          period: const Duration(milliseconds: 1400),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(color: base),
              // Status pill (top left)
              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  width: 36,
                  height: 18,
                  decoration: BoxDecoration(
                    color: highlight,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              // Avatar circle (top right)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: highlight,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              // Bottom name + scientific
              Positioned(
                left: 14,
                right: 14,
                bottom: 14,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 14,
                      decoration: BoxDecoration(
                        color: highlight,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 90,
                      height: 10,
                      decoration: BoxDecoration(
                        color: highlight,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
