import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) => _onItemTapped(index, context),
        indicatorColor: const Color(0xFFFF6B35).withValues(alpha: 0.2),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore, color: Color(0xFFFF6B35)),
            label: 'Missions',
          ),
          NavigationDestination(
            icon: Icon(Icons.sports_esports_outlined),
            selectedIcon: Icon(Icons.sports_esports, color: Color(0xFFFF6B35)),
            label: 'Games',
          ),
          NavigationDestination(
            icon: Icon(Icons.emoji_events_outlined),
            selectedIcon: Icon(Icons.emoji_events, color: Color(0xFFFF6B35)),
            label: 'Badges',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: Color(0xFFFF6B35)),
            label: 'Hero',
          ),
        ],
      ),
    );
  }
}
