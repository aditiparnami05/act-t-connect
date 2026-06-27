import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/database/hive_service.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/theme_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../shell/presentation/widgets/app_top_bar.dart';

/// App settings — theme, backup, language, printer, notifications.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(isDarkModeProvider);
    final offline = ref.watch(offlineModeProvider);

    return Scaffold(
      appBar: const AppTopBar(title: 'Settings'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SettingsTile(
            icon: Symbols.apartment,
            title: 'Business Profile',
            subtitle: 'Company details & GSTIN',
            onTap: () => context.push(AppRoutes.companyProfile),
          ),
          _SettingsTile(
            icon: Symbols.dark_mode,
            title: 'Theme',
            subtitle: isDark ? 'Dark Mode' : 'Light Mode',
            trailing: Switch(
              value: isDark,
              onChanged: (_) => ref.read(themeModeProvider.notifier).toggle(),
              activeThumbColor: AppColors.primary,
            ),
          ),
          _SettingsTile(
            icon: Symbols.cloud_off,
            title: 'Offline Mode',
            subtitle: offline ? 'Enabled' : 'Disabled',
            trailing: Switch(
              value: offline,
              onChanged: (v) => ref.read(offlineModeProvider.notifier).state = v,
              activeThumbColor: AppColors.primary,
            ),
          ),
          _SettingsTile(
            icon: Symbols.backup,
            title: 'Backup',
            subtitle: 'Backup data to cloud',
            onTap: () => _showSnack(context, 'Backup started'),
          ),
          _SettingsTile(
            icon: Symbols.restore,
            title: 'Restore',
            subtitle: 'Restore from backup',
            onTap: () => _showSnack(context, 'Select backup file'),
          ),
          _SettingsTile(
            icon: Symbols.language,
            title: 'Language',
            subtitle: 'English',
            onTap: () => _showSnack(context, 'Language settings'),
          ),
          _SettingsTile(
            icon: Symbols.print,
            title: 'Printer',
            subtitle: 'Configure thermal printer',
            onTap: () => _showSnack(context, 'Printer settings'),
          ),
          _SettingsTile(
            icon: Symbols.notifications,
            title: 'Notifications',
            subtitle: 'Manage alerts',
            onTap: () => _showSnack(context, 'Notification preferences'),
          ),
          const Divider(height: 32),
          _SettingsTile(
            icon: Symbols.info,
            title: 'About',
            subtitle: '${AppStrings.appName} v1.0.0',
            onTap: () => showAboutDialog(
              context: context,
              applicationName: AppStrings.appName,
              applicationVersion: '1.0.0',
              applicationIcon: Image.asset('assets/images/logo.png', height: 48),
              children: const [
                Text('Business ERP, Billing, Inventory & CRM'),
                SizedBox(height: 8),
                Text('© 2026 Act-T Connect. All rights reserved.'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Symbols.logout, color: AppColors.error),
            title: Text(
              AppStrings.logout,
              style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w600),
            ),
            onTap: () async {
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) context.go(AppRoutes.login);
            },
          ),
        ],
      ),
    );
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 22),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: trailing ?? const Icon(Symbols.chevron_right, size: 20),
        onTap: onTap,
      ),
    );
  }
}
