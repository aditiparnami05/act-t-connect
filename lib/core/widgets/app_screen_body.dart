import 'package:flutter/material.dart';

import '../constants/app_dimensions.dart';

/// Standard scrollable screen body with consistent horizontal padding.
class AppScreenBody extends StatelessWidget {
  const AppScreenBody({
    super.key,
    required this.child,
    this.padding,
    this.onRefresh,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    final body = Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppDimensions.maxContentWidth),
        child: Padding(
          padding: padding ??
              const EdgeInsets.symmetric(
                horizontal: AppDimensions.screenPaddingH,
                vertical: AppDimensions.space1,
              ),
          child: child,
        ),
      ),
    );

    if (onRefresh == null) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        child: body,
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh!,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        child: body,
      ),
    );
  }
}
