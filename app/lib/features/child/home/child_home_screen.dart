import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../config/dependency_injection.dart';
import '../../../models/child_profile.dart';
import '../../../models/game_specification.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/streak_badge.dart';
import '../../../widgets/xp_bar.dart';

class ChildHomeScreen extends ConsumerStatefulWidget {
  const ChildHomeScreen({super.key});

  @override
  ConsumerState<ChildHomeScreen> createState() => _ChildHomeScreenState();
}

class _ChildHomeScreenState extends ConsumerState<ChildHomeScreen> {
  ChildProfile? _activeChild;
  List<GameSpecification> _availableGames = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadChildData();
  }

  Future<void> _loadChildData() async {
    setState(() => _isLoading = true);
    try {
      final childRepo = ref.read(childRepositoryProvider);
      final children = await childRepo.getChildren();
      if (children.isNotEmpty) {
        _activeChild = children.first;
        final gameService = ref.read(gameServiceProvider);
        final games = await gameService.getGamesForChild(_activeChild!.id);
        if (mounted) {
          setState(() {
            _availableGames = games;
            _isLoading = false;
          });
        }
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (_) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _launchMission(GameSpecification game) async {
    if (_activeChild == null) return;
    try {
      final gameService = ref.read(gameServiceProvider);
      final session = await gameService.startSession(game.gameId, _activeChild!.id);
      if (mounted) {
        context.push('/game/${game.gameId}/${session.id}');
      }
    } catch (e) {
      if (mounted) {
        // Fallback for offline/cached games
        context.push('/game/${game.gameId}/offline-${DateTime.now().millisecondsSinceEpoch}');
      }
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

    final childName = _activeChild?.name ?? 'Explorer';
    final currentStreak = _activeChild?.currentStreak ?? 1;
    final totalXp = _activeChild?.xpTotal ?? 150;
    final currentLevel = _activeChild?.currentLevel ?? 1;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadChildData,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Header: Greeting, Avatar, Parent Switcher
                Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: const Color(0xFFFF6B35),
                      child: Text(
                        childName.isNotEmpty ? childName[0].toUpperCase() : 'E',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hey $childName! 🚀',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Ready for today\'s quest?',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    StreakBadge(streak: currentStreak),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.shield_outlined, color: Colors.grey),
                      tooltip: 'Parent Zone',
                      onPressed: () => context.go('/parent'),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Gamified XP Bar Card
                AppCard.elevated(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: XpBar(
                    currentXp: totalXp % 500,
                    nextLevelXp: 500,
                    level: currentLevel,
                  ),
                ),

                const SizedBox(height: 24),

                // Featured Mission Banner
                Text(
                  '⭐ Active Mission',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                AppCard.game(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'SCIENCE QUEST 💧',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              '+250 XP 🏆',
                              style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _availableGames.isNotEmpty
                            ? _availableGames.first.title
                            : 'أنقذ كوكب واتيريا (Save Planet Wateria)',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _availableGames.isNotEmpty
                            ? _availableGames.first.description
                            : 'انطلق في رحلة لإنقاذ الكوكب من الجفاف واهزم زعيم التبخر!',
                        style: const TextStyle(color: Colors.white70, fontSize: 13),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 20),
                      AppButton.game(
                        label: '▶️ Start Mission Now',
                        onPressed: () {
                          if (_availableGames.isNotEmpty) {
                            _launchMission(_availableGames.first);
                          } else {
                            // Launch sample demo game
                            context.push('/game/sample-water-cycle/demo-session-1');
                          }
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // Quick Missions Grid Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '🎮 More Missions',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.go('/child/games'),
                      child: const Text('View All'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // 2-Column Mini Mission Cards
                Row(
                  children: [
                    Expanded(
                      child: AppCard.elevated(
                        onTap: () => context.push('/game/sample-fractions/demo-session-2'),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('🔢', style: TextStyle(fontSize: 28)),
                            const SizedBox(height: 8),
                            const Text(
                              'Fraction Quest',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Math • 4 Levels',
                              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                            ),
                            const SizedBox(height: 10),
                            const Row(
                              children: [
                                Icon(Icons.star, size: 16, color: Colors.amber),
                                SizedBox(width: 4),
                                Text('+200 XP', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: AppCard.elevated(
                        onTap: () {
                          if (_availableGames.isNotEmpty) {
                            _launchMission(_availableGames.first);
                          } else {
                            context.push('/game/sample-water-cycle/demo-session-1');
                          }
                        },
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('🔬', style: TextStyle(fontSize: 28)),
                            const SizedBox(height: 8),
                            const Text(
                              'كوكب واتيريا',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'علوم • معركة الزعيم',
                              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                            ),
                            const SizedBox(height: 10),
                            const Row(
                              children: [
                                Icon(Icons.star, size: 16, color: Colors.amber),
                                SizedBox(width: 4),
                                Text('+300 XP', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
