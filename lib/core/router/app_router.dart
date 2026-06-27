import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/analytics/presentation/screens/analytics_screen.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/customers/presentation/screens/customer_detail_screen.dart';
import '../../features/customers/presentation/screens/customers_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/employees/presentation/screens/employees_screen.dart';
import '../../features/expenses/presentation/screens/expenses_screen.dart';
import '../../features/inventory/presentation/screens/inventory_screen.dart';
import '../../features/inventory/presentation/screens/product_detail_screen.dart';
import '../../features/invoices/presentation/screens/create_invoice_screen.dart';
import '../../features/invoices/presentation/screens/invoice_detail_screen.dart';
import '../../features/invoices/presentation/screens/invoices_screen.dart';
import '../../features/parties/presentation/screens/parties_screen.dart';
import '../../features/payments/presentation/screens/payments_screen.dart';
import '../../features/purchases/presentation/screens/purchases_screen.dart';
import '../../features/reports/presentation/screens/reports_screen.dart';
import '../../features/settings/presentation/screens/company_profile_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/shell/presentation/screens/main_shell.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/suppliers/presentation/screens/suppliers_screen.dart';
import 'app_routes.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

/// Notifies [GoRouter] when auth changes without recreating the router instance.
final _routerRefreshProvider = Provider<Listenable>((ref) {
  final notifier = _RouterRefreshNotifier();
  ref.listen<AuthState>(authProvider, (previous, next) => notifier.notify());
  ref.onDispose(notifier.dispose);
  return notifier;
});

class _RouterRefreshNotifier extends ChangeNotifier {
  void notify() => notifyListeners();
}

/// GoRouter configuration with auth redirect and shell navigation.
final routerProvider = Provider<GoRouter>((ref) {
  final refreshListenable = ref.watch(_routerRefreshProvider);

  final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    refreshListenable: refreshListenable,
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final isLoggedIn = ref.read(authProvider).isAuthenticated;
      final location = state.matchedLocation;
      final isLoginRoute = location == AppRoutes.login;
      final isSplashRoute = location == AppRoutes.splash;

      if (isSplashRoute && isLoggedIn) return AppRoutes.dashboard;
      if (isSplashRoute) return null;

      if (!isLoggedIn && !isLoginRoute) return AppRoutes.login;
      if (isLoggedIn && isLoginRoute) return AppRoutes.dashboard;
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SplashScreen(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              child,
        ),
      ),
      GoRoute(
        path: AppRoutes.login,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.dashboard,
            pageBuilder: (context, state) => _fadePage(state, const DashboardScreen()),
          ),
          GoRoute(
            path: AppRoutes.invoices,
            pageBuilder: (context, state) => _fadePage(state, const InvoicesScreen()),
            routes: [
              GoRoute(
                path: 'create',
                parentNavigatorKey: _rootNavigatorKey,
                pageBuilder: (context, state) =>
                    _slidePage(state, const CreateInvoiceScreen()),
              ),
              GoRoute(
                path: ':id',
                parentNavigatorKey: _rootNavigatorKey,
                pageBuilder: (context, state) => _slidePage(
                  state,
                  InvoiceDetailScreen(id: state.pathParameters['id']!),
                ),
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.inventory,
            pageBuilder: (context, state) => _fadePage(state, const InventoryScreen()),
            routes: [
              GoRoute(
                path: ':id',
                parentNavigatorKey: _rootNavigatorKey,
                pageBuilder: (context, state) => _slidePage(
                  state,
                  ProductDetailScreen(id: state.pathParameters['id']!),
                ),
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.parties,
            pageBuilder: (context, state) => _fadePage(state, const PartiesScreen()),
          ),
          GoRoute(
            path: AppRoutes.settings,
            pageBuilder: (context, state) => _fadePage(state, const SettingsScreen()),
          ),
          GoRoute(
            path: AppRoutes.customers,
            pageBuilder: (context, state) => _fadePage(state, const CustomersScreen()),
            routes: [
              GoRoute(
                path: 'add',
                parentNavigatorKey: _rootNavigatorKey,
                pageBuilder: (context, state) =>
                    _slidePage(state, const CustomerDetailScreen()),
              ),
              GoRoute(
                path: ':id',
                parentNavigatorKey: _rootNavigatorKey,
                pageBuilder: (context, state) => _slidePage(
                  state,
                  CustomerDetailScreen(id: state.pathParameters['id']),
                ),
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.suppliers,
            pageBuilder: (context, state) => _fadePage(state, const SuppliersScreen()),
          ),
          GoRoute(
            path: AppRoutes.purchases,
            pageBuilder: (context, state) => _fadePage(state, const PurchasesScreen()),
          ),
          GoRoute(
            path: AppRoutes.payments,
            pageBuilder: (context, state) => _fadePage(state, const PaymentsScreen()),
          ),
          GoRoute(
            path: AppRoutes.reports,
            pageBuilder: (context, state) => _fadePage(state, const ReportsScreen()),
          ),
          GoRoute(
            path: AppRoutes.expenses,
            pageBuilder: (context, state) => _fadePage(state, const ExpensesScreen()),
          ),
          GoRoute(
            path: AppRoutes.analytics,
            pageBuilder: (context, state) => _fadePage(state, const AnalyticsScreen()),
          ),
          GoRoute(
            path: AppRoutes.employees,
            pageBuilder: (context, state) => _fadePage(state, const EmployeesScreen()),
          ),
          GoRoute(
            path: AppRoutes.companyProfile,
            pageBuilder: (context, state) =>
                _slidePage(state, const CompanyProfileScreen()),
          ),
        ],
      ),
    ],
  );

  ref.onDispose(router.dispose);
  return router;
});

CustomTransitionPage<void> _fadePage(GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}

CustomTransitionPage<void> _slidePage(GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 350),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final offsetAnimation = Tween<Offset>(
        begin: const Offset(0, 0.05),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
      return FadeTransition(
        opacity: animation,
        child: SlideTransition(position: offsetAnimation, child: child),
      );
    },
  );
}
