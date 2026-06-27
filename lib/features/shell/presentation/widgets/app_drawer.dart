import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/router/app_routes.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../shared/providers/user_profile_provider.dart';

/// Navigation drawer with company profile and menu items.
class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final profile = ref.watch(userProfileProvider);

    return Drawer(
      child: Column(
        children: [
          _DrawerHeader(
            companyName: profile.businessName,
            userName: auth.userName,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _DrawerItem(
                  icon: Symbols.apartment,
                  label: 'Company Profile',
                  onTap: () => _navigate(context, AppRoutes.companyProfile),
                ),
                const Divider(indent: 16, endIndent: 16),
                _DrawerItem(
                  icon: Symbols.dashboard,
                  label: 'Dashboard',
                  onTap: () => _navigate(context, AppRoutes.dashboard),
                ),
                _DrawerItem(
                  icon: Symbols.receipt_long,
                  label: 'Invoices',
                  onTap: () => _navigate(context, AppRoutes.invoices),
                ),
                _DrawerItem(
                  icon: Symbols.shopping_cart,
                  label: 'Purchases',
                  onTap: () => _navigate(context, AppRoutes.purchases),
                ),
                _DrawerItem(
                  icon: Symbols.inventory_2,
                  label: 'Inventory',
                  onTap: () => _navigate(context, AppRoutes.inventory),
                ),
                _DrawerItem(
                  icon: Symbols.person,
                  label: 'Customers',
                  onTap: () => _navigate(context, AppRoutes.customers),
                ),
                _DrawerItem(
                  icon: Symbols.local_shipping,
                  label: 'Suppliers',
                  onTap: () => _navigate(context, AppRoutes.suppliers),
                ),
                _DrawerItem(
                  icon: Symbols.payments,
                  label: 'Expenses',
                  onTap: () => _navigate(context, AppRoutes.expenses),
                ),
                _DrawerItem(
                  icon: Symbols.assessment,
                  label: 'Reports',
                  onTap: () => _navigate(context, AppRoutes.reports),
                ),
                _DrawerItem(
                  icon: Symbols.analytics,
                  label: 'Analytics',
                  onTap: () => _navigate(context, AppRoutes.analytics),
                ),
                _DrawerItem(
                  icon: Symbols.badge,
                  label: 'Employees',
                  onTap: () => _navigate(context, AppRoutes.employees),
                ),
                const Divider(indent: 16, endIndent: 16),
                _DrawerItem(
                  icon: Symbols.settings,
                  label: 'Settings',
                  onTap: () => _navigate(context, AppRoutes.settings),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Symbols.logout, color: AppColors.error),
            title: Text(
              AppStrings.logout,
              style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w600),
            ),
            onTap: () async {
              Navigator.pop(context);
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) context.go(AppRoutes.login);
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  void _navigate(BuildContext context, String route) {
    Navigator.pop(context);
    context.go(route);
  }
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader({
    required this.companyName,
    required this.userName,
  });

  final String companyName;
  final String userName;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 48, 20, 20),
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset(
              'assets/images/logo.png',
              height: 40,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            companyName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            userName,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textSecondary, size: 22),
      title: Text(label, style: const TextStyle(fontSize: 14)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
      onTap: onTap,
    );
  }
}
