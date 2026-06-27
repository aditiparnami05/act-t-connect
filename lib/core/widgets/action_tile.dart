import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../theme/app_typography.dart';

/// Quick action tile for dashboard grid — sized by grid [mainAxisExtent].
class ActionTile extends StatelessWidget {
  const ActionTile({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.color,
    this.index = 0,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;
  final int index;

  @override
  Widget build(BuildContext context) {
    final accent = color ?? AppColors.primary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radius),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(AppDimensions.radius),
            boxShadow: AppDimensions.cardShadow(),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 4,
              vertical: AppDimensions.space1,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: accent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                  ),
                  child: Icon(icon, color: accent, size: AppDimensions.iconSizeSm),
                ),
                const SizedBox(height: 6),
                Expanded(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.label(AppColors.textPrimary).copyWith(
                        fontSize: 11,
                        height: 1.15,
                      ),
                    ),
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
