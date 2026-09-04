import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_colors.dart';

class ChildShellScreen extends StatelessWidget {
  final Widget child;

  const ChildShellScreen({required this.child, super.key});

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/child/games')) return 1;
    if (location.startsWith('/child/achievements')) return 2;
    if (location.startsWith('/child/profile')) return 3;
    if (location.startsWith('/child')) return 0;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/child');
        break;
      case 1:
        context.go('/child/games');
        break;
      case 2:
        context.go('/child/achievements');
        break;
      case 3:
        context.go('/child/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);
    final l = AppLocalizations.of(context)!;
    const childColor = AppColors.childPrimary;

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) => _onItemTapped(index, context),
        indicatorColor: childColor.withValues(alpha: 0.2),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.explore_outlined),
            selectedIcon: const Icon(Icons.explore, color: childColor),
            label: l.missions,
          ),
          NavigationDestination(
            icon: const Icon(Icons.sports_esports_outlined),
            selectedIcon: const Icon(Icons.sports_esports, color: childColor),
            label: l.games,
          ),
          NavigationDestination(
            icon: const Icon(Icons.emoji_events_outlined),
            selectedIcon: const Icon(Icons.emoji_events, color: childColor),
            label: l.badges,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person, color: childColor),
            label: l.hero,
          ),
        ],
      ),
    );
  }
}
