import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../shared/providers/user_profile_provider.dart';
import 'shell_scope.dart';

/// Reusable top app bar for feature screens inside the main shell.
class AppTopBar extends ConsumerWidget implements PreferredSizeWidget {
  const AppTopBar({
    super.key,
    this.title,
    this.showGreeting = false,
    this.actions,
    this.showDrawer = true,
  });

  final String? title;
  final bool showGreeting;
  final List<Widget>? actions;
  final bool showDrawer;

  @override
  Size get preferredSize => Size.fromHeight(
        showGreeting ? 64 : AppDimensions.appBarHeight,
      );

  void _openDrawer(BuildContext context) {
    final shell = ShellScope.maybeOf(context);
    if (shell != null) {
      shell.openDrawer();
      return;
    }
    Scaffold.of(context).openDrawer();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good Morning'
        : hour < 17
            ? 'Good Afternoon'
            : 'Good Evening';

    return AppBar(
      toolbarHeight: showGreeting ? 64 : AppDimensions.appBarHeight,
      leading: showDrawer
          ? IconButton(
              icon: const Icon(Symbols.menu),
              onPressed: () => _openDrawer(context),
            )
          : null,
      title: showGreeting
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$greeting,',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.1,
                      ),
                ),
                Text(
                  profile.displayName.split(' ').first,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        height: 1.1,
                      ),
                ),
              ],
            )
          : title != null
              ? Text(title!)
              : null,
      actions: [
        if (showGreeting) ...[
          IconButton(
            icon: Badge(
              smallSize: 8,
              child: const Icon(Symbols.notifications),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No new notifications')),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => context.push(AppRoutes.settings),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primary.withValues(alpha: 0.15),
                child: Text(
                  profile.displayName.isNotEmpty
                      ? profile.displayName[0].toUpperCase()
                      : 'U',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
        ...?actions,
      ],
    );
  }
}
