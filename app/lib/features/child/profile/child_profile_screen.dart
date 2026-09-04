import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../config/dependency_injection.dart';
import '../../../models/child_profile.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/xp_bar.dart';

class ChildProfileScreen extends ConsumerStatefulWidget {
  const ChildProfileScreen({super.key});

  @override
  ConsumerState<ChildProfileScreen> createState() => _ChildProfileScreenState();
}

class _ChildProfileScreenState extends ConsumerState<ChildProfileScreen> {
  ChildProfile? _child;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadChild();
  }

  Future<void> _loadChild() async {
    setState(() => _isLoading = true);
    try {
      final childRepo = ref.read(childRepositoryProvider);
      final children = await childRepo.getChildren();
      if (children.isNotEmpty) {
        _child = children.first;
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final name = _child?.name ?? 'Super Explorer';
    final age = _child?.age ?? 9;
    final level = _child?.currentLevel ?? 1;
    final totalXp = _child?.xpTotal ?? 250;
    final streak = _child?.currentStreak ?? 2;

    return Scaffold(
      appBar: AppBar(
        title: const Text('🦸 Hero Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shield_outlined),
            tooltip: 'Parent Dashboard',
            onPressed: () => context.go('/parent'),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Hero Avatar & Level
              AppCard.elevated(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 46,
                          backgroundColor: const Color(0xFFFF6B35),
                          child: Text(
                            name.isNotEmpty ? name[0].toUpperCase() : 'E',
                            style: const TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.amber,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.star, color: Colors.white, size: 18),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      name,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Level $level Explorer • Age $age',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 20),
                    XpBar(
                      currentXp: totalXp % 500,
                      nextLevelXp: 500,
                      level: level,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Lifetime Stats 4-Pack Grid
              Row(
                children: [
                  Expanded(
                    child: AppCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Text('🔥', style: TextStyle(fontSize: 28)),
                          const SizedBox(height: 6),
                          Text('$streak Days', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          const Text('Active Streak', style: TextStyle(color: Colors.grey, fontSize: 11)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Text('🏆', style: TextStyle(fontSize: 28)),
                          const SizedBox(height: 6),
                          Text('$totalXp', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.amber)),
                          const Text('Total XP', style: TextStyle(color: Colors.grey, fontSize: 11)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: AppCard(
                      padding: const EdgeInsets.all(16),
                      child: const Column(
                        children: [
                          Text('🎮', style: TextStyle(fontSize: 28)),
                          SizedBox(height: 6),
                          Text('4 Quests', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          Text('Completed', style: TextStyle(color: Colors.grey, fontSize: 11)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppCard(
                      padding: const EdgeInsets.all(16),
                      child: const Column(
                        children: [
                          Text('🌟', style: TextStyle(fontSize: 28)),
                          SizedBox(height: 6),
                          Text('3 Badges', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                          Text('Collected', style: TextStyle(color: Colors.grey, fontSize: 11)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Action buttons
              AppButton.game(
                label: '🚀 Play Today\'s Quests',
                onPressed: () => context.go('/child'),
              ),
              const SizedBox(height: 12),
              AppButton.secondary(
                label: '🛡️ Switch to Parent Mode',
                icon: Icons.shield_outlined,
                onPressed: () => context.go('/parent'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
