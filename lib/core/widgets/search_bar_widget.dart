import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';

/// Global search bar widget.
class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({
    super.key,
    required this.controller,
    this.hint = 'Search...',
    this.onChanged,
    this.onFilterTap,
    this.showFilter = true,
  });

  final TextEditingController controller;
  final String hint;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFilterTap;
  final bool showFilter;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: const Icon(Icons.search_rounded, color: AppColors.textSecondary),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              filled: true,
              fillColor: Theme.of(context).cardColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radius),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        if (showFilter) ...[
          const SizedBox(width: 10),
          Material(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
            child: InkWell(
              onTap: onFilterTap,
              borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              child: Container(
                padding: const EdgeInsets.all(14),
                child: const Icon(Icons.tune_rounded, color: AppColors.primary),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
