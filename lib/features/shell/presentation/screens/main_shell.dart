import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/router/app_routes.dart';
import '../widgets/app_drawer.dart';
import '../widgets/shell_scope.dart';

/// Main shell with bottom navigation, drawer, and FAB.
class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;

  static const _tabs = [
    _NavItem(path: AppRoutes.dashboard, icon: Symbols.dashboard, label: 'Dashboard'),
    _NavItem(path: AppRoutes.invoices, icon: Symbols.receipt_long, label: 'Invoices'),
    _NavItem(path: AppRoutes.inventory, icon: Symbols.inventory_2, label: 'Inventory'),
    _NavItem(path: AppRoutes.parties, icon: Symbols.groups, label: 'Parties'),
    _NavItem(path: AppRoutes.settings, icon: Symbols.settings, label: 'Settings'),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncIndexWithRoute();
  }

  void _syncIndexWithRoute() {
    final location = GoRouterState.of(context).matchedLocation;
    for (var i = 0; i < _tabs.length; i++) {
      if (location == _tabs[i].path || location.startsWith('${_tabs[i].path}/')) {
        if (_currentIndex != i) setState(() => _currentIndex = i);
        return;
      }
    }
  }

  void _onTabTapped(int index) {
    if (index != _currentIndex) {
      setState(() => _currentIndex = index);
      context.go(_tabs[index].path);
    }
  }

  bool get _showFab {
    final location = GoRouterState.of(context).matchedLocation;
    return location == AppRoutes.dashboard || location == AppRoutes.invoices;
  }

  @override
  Widget build(BuildContext context) {
    final showBottomNav = _isMainTab(GoRouterState.of(context).matchedLocation);

    return ShellScope(
      openDrawer: () => _scaffoldKey.currentState?.openDrawer(),
      child: Scaffold(
        key: _scaffoldKey,
        drawer: const AppDrawer(),
        body: widget.child,
        floatingActionButton: _showFab
            ? FloatingActionButton.extended(
                onPressed: () => context.push(AppRoutes.invoiceCreate),
                icon: const Icon(Symbols.add),
                label: const Text('Create Invoice'),
              )
            : null,
        bottomNavigationBar: showBottomNav
            ? NavigationBar(
                selectedIndex: _currentIndex,
                labelBehavior: MediaQuery.sizeOf(context).width < 400
                    ? NavigationDestinationLabelBehavior.onlyShowSelected
                    : NavigationDestinationLabelBehavior.alwaysShow,
                onDestinationSelected: _onTabTapped,
                destinations: _tabs
                    .map(
                      (t) => NavigationDestination(
                        icon: Icon(t.icon),
                        selectedIcon: Icon(t.icon, fill: 1),
                        label: t.label,
                      ),
                    )
                    .toList(),
              )
            : null,
      ),
    );
  }

  bool _isMainTab(String location) {
    return _tabs.any((t) => location == t.path);
  }
}

class _NavItem {
  const _NavItem({required this.path, required this.icon, required this.label});
  final String path;
  final IconData icon;
  final String label;
}
