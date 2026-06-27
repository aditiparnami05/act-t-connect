import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';

/// Skeleton loading placeholder for cards.
class SkeletonLoader extends StatelessWidget {
  const SkeletonLoader({
    super.key,
    this.height = 100,
    this.width,
    this.borderRadius,
  });

  final double height;
  final double? width;
  final double? borderRadius;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
      highlightColor: isDark ? Colors.grey.shade700 : Colors.grey.shade100,
      child: Container(
        height: height,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius ?? AppDimensions.radius),
        ),
      ),
    );
  }
}

/// Grid of skeleton cards for dashboard loading — scroll-safe, no fixed viewport overflow.
class DashboardSkeleton extends StatelessWidget {
  const DashboardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final compact = size.height < 720;
    final kpiHeight = compact ? 96.0 : 104.0;
    final chartHeight = compact ? 140.0 : 180.0;
    final sectionHeight = compact ? 120.0 : 160.0;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.screenPaddingH,
        vertical: AppDimensions.space1,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: size.width >= 600 ? 3 : 2,
              crossAxisSpacing: AppDimensions.space2,
              mainAxisSpacing: AppDimensions.space2,
              mainAxisExtent: kpiHeight,
            ),
            children: List.generate(
              6,
              (_) => SkeletonLoader(height: kpiHeight, borderRadius: AppDimensions.radius),
            ),
          ),
          const SizedBox(height: AppDimensions.sectionGap),
          SkeletonLoader(height: 24, borderRadius: AppDimensions.radiusSm),
          const SizedBox(height: AppDimensions.elementGap),
          GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: AppDimensions.space2,
              mainAxisSpacing: AppDimensions.space2,
              mainAxisExtent: compact ? 100.0 : 112.0,
            ),
            children: List.generate(
              8,
              (_) => SkeletonLoader(
                height: compact ? 100 : 112,
                borderRadius: AppDimensions.radius,
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.sectionGap),
          SkeletonLoader(height: chartHeight),
          const SizedBox(height: AppDimensions.space2),
          SkeletonLoader(height: chartHeight),
          const SizedBox(height: AppDimensions.space2),
          SkeletonLoader(height: sectionHeight),
        ],
      ),
    );
  }
}

/// Centered loading indicator with brand color.
class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: AppColors.primary),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(message!, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ],
      ),
    );
  }
}
