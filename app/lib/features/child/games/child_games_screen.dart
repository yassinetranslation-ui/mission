import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../config/dependency_injection.dart';
import '../../../models/game_specification.dart';
import '../../../models/child_profile.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_card.dart';

class ChildGamesScreen extends ConsumerStatefulWidget {
  const ChildGamesScreen({super.key});

  @override
  ConsumerState<ChildGamesScreen> createState() => _ChildGamesScreenState();
}

class _ChildGamesScreenState extends ConsumerState<ChildGamesScreen> {
  List<GameSpecification> _games = [];
  ChildProfile? _activeChild;
  bool _isLoading = true;
  String _selectedSubject = 'All';

  final List<String> _subjects = ['All', 'Science 🔬', 'Math 🔢', 'Languages 📚', 'General 🌍'];

  @override
  void initState() {
    super.initState();
    _loadGames();
  }

  Future<void> _loadGames() async {
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
            _games = games;
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

  Future<void> _launchGame(GameSpecification game) async {
    if (_activeChild == null) {
      context.push('/game/${game.gameId}/demo-session');
      return;
    }
    try {
      final gameService = ref.read(gameServiceProvider);
      final session = await gameService.startSession(game.gameId, _activeChild!.id);
      if (mounted) {
        context.push('/game/${game.gameId}/${session.id}');
      }
    } catch (_) {
      if (mounted) {
        context.push('/game/${game.gameId}/offline-${DateTime.now().millisecondsSinceEpoch}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('🎮 Missions & Quests'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Subject Filter Chips
            SizedBox(
              height: 50,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                scrollDirection: Axis.horizontal,
                itemCount: _subjects.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final subject = _subjects[index];
                  final isSelected = _selectedSubject == subject;
                  return ChoiceChip(
                    label: Text(subject),
                    selected: isSelected,
                    selectedColor: const Color(0xFFFF6B35).withValues(alpha: 0.2),
                    labelStyle: TextStyle(
                      color: isSelected ? const Color(0xFFFF6B35) : theme.colorScheme.onSurface,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    onSelected: (val) {
                      if (val) setState(() => _selectedSubject = subject);
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 8),

            // Missions List
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: _loadGames,
                      child: ListView(
                        padding: const EdgeInsets.all(20),
                        children: [
                          // Demo Quest 1: Water Cycle (Arabic)
                          _buildMissionCard(
                            title: 'أنقذ كوكب واتيريا (Save Planet Wateria)',
                            description: 'تحدي دورة المياه في الطبيعة: التبخر والتكثف وهزيمة وحش الجفاف!',
                            subject: 'العلوم 🔬',
                            levelsCount: 4,
                            xpReward: 300,
                            gameId: 'sample-water-cycle',
                            color: const Color(0xFF6C63FF),
                          ),

                          const SizedBox(height: 16),

                          // Demo Quest 2: Fraction Quest (English)
                          _buildMissionCard(
                            title: 'Fraction Quest: The Pizza Realm',
                            description: 'Master fractions, equivalent parts, and defeat the Fraction Golem!',
                            subject: 'Math 🔢',
                            levelsCount: 4,
                            xpReward: 250,
                            gameId: 'sample-fractions',
                            color: const Color(0xFFFF6B35),
                          ),

                          // Dynamically generated games
                          ..._games.map((g) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: _buildDynamicMissionCard(g),
                            );
                          }),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMissionCard({
    required String title,
    required String description,
    required String subject,
    required int levelsCount,
    required int xpReward,
    required String gameId,
    required Color color,
  }) {
    return AppCard.elevated(
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
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  subject,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    '+$xpReward XP',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 13, height: 1.3),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.layers_outlined, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text('$levelsCount Levels + Boss Fight', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
              const Spacer(),
              AppButton.game(
                label: '▶️ Play',
                size: AppButtonSize.sm,
                onPressed: () {
                  context.push('/game/$gameId/demo-session-${DateTime.now().millisecondsSinceEpoch}');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicMissionCard(GameSpecification game) {
    return AppCard.elevated(
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
                  color: const Color(0xFF00BFA6).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Custom Mission ✨',
                  style: TextStyle(
                    color: Color(0xFF00BFA6),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    '+${game.xpReward} XP',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            game.title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            game.description,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 13, height: 1.3),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.layers_outlined, size: 16, color: Colors.grey.shade600),
              const SizedBox(width: 4),
              Text('${game.levels.length} Levels', style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
              const Spacer(),
              AppButton.game(
                label: '▶️ Play',
                size: AppButtonSize.sm,
                onPressed: () => _launchGame(game),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
