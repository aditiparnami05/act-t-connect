import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../theme/app_typography.dart';

/// Dashboard metric summary card with optional gradient accent.
class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.subtitle,
    this.color,
    this.onTap,
    this.useGradient = false,
  });

  final String title;
  final String value;
  final IconData icon;
  final String? subtitle;
  final Color? color;
  final VoidCallback? onTap;
  final bool useGradient;

  @override
  Widget build(BuildContext context) {
    final accent = color ?? AppColors.primary;
    final titleColor = useGradient ? Colors.white70 : AppColors.textSecondary;
    final valueColor = useGradient ? Colors.white : AppColors.textPrimary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radius),
        child: Ink(
          decoration: BoxDecoration(
            color: useGradient ? null : AppColors.card,
            gradient: useGradient
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [accent, accent.withValues(alpha: 0.85)],
                  )
                : null,
            borderRadius: BorderRadius.circular(AppDimensions.radius),
            boxShadow: AppDimensions.cardShadow(
              color: useGradient ? accent : Colors.black,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.elementGap,
              vertical: 10,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: useGradient
                        ? Colors.white.withValues(alpha: 0.2)
                        : accent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                  ),
                  child: Icon(
                    icon,
                    color: useGradient ? Colors.white : accent,
                    size: AppDimensions.iconSizeSm,
                  ),
                ),
                const SizedBox(width: AppDimensions.elementGap),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.caption(titleColor).copyWith(
                          fontSize: 11,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.bodyMedium(valueColor).copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          height: 1.1,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.label(
                            useGradient ? Colors.white60 : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
