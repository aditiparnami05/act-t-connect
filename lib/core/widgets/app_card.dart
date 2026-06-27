import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../theme/app_typography.dart';

/// Standard elevated card — consistent radius, padding, and shadow.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.color,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final content = Container(
      width: double.infinity,
      margin: margin ?? const EdgeInsets.only(bottom: AppDimensions.sectionGap),
      padding: padding ?? const EdgeInsets.all(AppDimensions.cardPaddingLg),
      decoration: BoxDecoration(
        color: color ?? AppColors.card,
        borderRadius: BorderRadius.circular(AppDimensions.radius),
        boxShadow: AppDimensions.cardShadow(),
      ),
      child: child,
    );

    if (onTap == null) return content;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radius),
        child: content,
      ),
    );
  }
}

/// Card section header row — icon + title + optional trailing.
class AppCardHeader extends StatelessWidget {
  const AppCardHeader({
    super.key,
    required this.title,
    this.icon,
    this.trailing,
  });

  final String title;
  final IconData? icon;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            ),
            child: Icon(icon, color: AppColors.primary, size: AppDimensions.iconSizeSm),
          ),
          const SizedBox(width: AppDimensions.elementGap),
        ],
        Expanded(
          child: Text(title, style: context.sectionTitleStyle),
        ),
        ?trailing,
      ],
    );
  }
}
