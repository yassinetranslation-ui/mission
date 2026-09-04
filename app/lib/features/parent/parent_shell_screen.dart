import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/app_localizations.dart';

class ParentShellScreen extends StatelessWidget {
  final Widget child;

  const ParentShellScreen({required this.child, super.key});

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/parent/children')) return 1;
    if (location.startsWith('/parent/upload')) return 2;
    if (location.startsWith('/parent/settings')) return 3;
    if (location.startsWith('/parent')) return 0;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/parent');
        break;
      case 1:
        context.go('/parent/children');
        break;
      case 2:
        context.go('/parent/upload');
        break;
      case 3:
        context.go('/parent/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) => _onItemTapped(index, context),
        indicatorColor: theme.colorScheme.primary.withValues(alpha: 0.15),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: l.home,
          ),
          NavigationDestination(
            icon: const Icon(Icons.people_outline),
            selectedIcon: const Icon(Icons.people),
            label: l.children,
          ),
          NavigationDestination(
            icon: const Icon(Icons.add_circle_outline),
            selectedIcon: const Icon(Icons.add_circle),
            label: l.upload,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: l.settings,
          ),
        ],
      ),
    );
  }
}
