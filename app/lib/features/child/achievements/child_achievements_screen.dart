import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../config/dependency_injection.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/child_profile.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/confetti_overlay.dart';

class ChildAchievementsScreen extends ConsumerStatefulWidget {
  const ChildAchievementsScreen({super.key});

  @override
  ConsumerState<ChildAchievementsScreen> createState() => _ChildAchievementsScreenState();
}

class _ChildAchievementsScreenState extends ConsumerState<ChildAchievementsScreen> {
  ChildProfile? _activeChild;
  bool _isLoading = true;

  final List<Map<String, dynamic>> _badges = [
    {
      'id': 'first_mission',
      'title': 'First Mission 🌟',
      'arabicTitle': 'المهمة الأولى',
      'description': 'Completed your very first educational quest!',
      'icon': '🌟',
      'xp': 50,
      'isUnlocked': true,
      'color': Colors.amber,
    },
    {
      'id': 'science_explorer',
      'title': 'Science Explorer 🔬',
      'arabicTitle': 'مستكشف العلوم',
      'description': 'Mastered a science lesson with high accuracy.',
      'icon': '🔬',
      'xp': 100,
      'isUnlocked': true,
      'color': const Color(0xFF6C63FF),
    },
    {
      'id': 'streak_flame',
      'title': 'Streak Master 🔥',
      'arabicTitle': 'شعلة الاستمرار',
      'description': 'Maintained a learning streak of 3+ days.',
      'icon': '🔥',
      'xp': 200,
      'isUnlocked': true,
      'color': const Color(0xFFFF6B35),
    },
    {
      'id': 'boss_slayer',
      'title': 'Boss Slayer ⚔️',
      'arabicTitle': 'قاهر الزعماء',
      'description': 'Defeated a Boss Battle without losing all lives.',
      'icon': '⚔️',
      'xp': 250,
      'isUnlocked': false,
      'color': Colors.red,
    },
    {
      'id': 'perfect_score',
      'title': 'Perfect Score 🎯',
      'arabicTitle': 'العلامة الكاملة',
      'description': 'Achieved 100% accuracy on any mission.',
      'icon': '🎯',
      'xp': 150,
      'isUnlocked': false,
      'color': Colors.green,
    },
    {
      'id': 'math_wizard',
      'title': 'Math Wizard 🧙‍♂️',
      'arabicTitle': 'ساحر الرياضيات',
      'description': 'Conquered the Fraction Quest challenges.',
      'icon': '🧙‍♂️',
      'xp': 150,
      'isUnlocked': false,
      'color': Colors.teal,
    },
  ];

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
        _activeChild = children.first;
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showBadgeDetails(Map<String, dynamic> badge) {
    final isUnlocked = badge['isUnlocked'] as bool;
    if (isUnlocked) {
      ConfettiOverlay.show(context);
    }

    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(badge['icon'], style: const TextStyle(fontSize: 56)),
            const SizedBox(height: 12),
            Text(
              badge['title'],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              badge['arabicTitle'],
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
            const SizedBox(height: 12),
            Text(
              badge['description'],
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isUnlocked ? Colors.green.shade100 : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                isUnlocked ? '+${badge["xp"]} XP 🏆' : '${AppLocalizations.of(context)!.locked} 🔒',
                style: TextStyle(
                  color: isUnlocked ? Colors.green.shade900 : Colors.grey.shade700,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: Text(AppLocalizations.of(context)!.awesome),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;
    final unlockedCount = _badges.where((b) => b['isUnlocked'] == true).length;
    final childName = _activeChild?.name ?? l.explorer;

    return Scaffold(
      appBar: AppBar(
        title: Text('🏆 $childName — ${l.badges}'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Achievement Header Summary Card
              AppCard.elevated(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.emoji_events, size: 36, color: Colors.amber),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l.badgesUnlocked(unlockedCount, _badges.length),
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: unlockedCount / _badges.length,
                              minHeight: 8,
                              backgroundColor: Colors.grey.shade200,
                              valueColor: const AlwaysStoppedAnimation(Colors.amber),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            l.keepPlayingCollect,
                            style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Text(
                l.explorerBadges,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // 2-Column Badges Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _badges.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.95,
                ),
                itemBuilder: (context, index) {
                  final badge = _badges[index];
                  final isUnlocked = badge['isUnlocked'] as bool;

                  return GestureDetector(
                    onTap: () => _showBadgeDetails(badge),
                    child: AppCard.elevated(
                      padding: const EdgeInsets.all(16),
                      color: isUnlocked ? theme.colorScheme.surface : Colors.grey.shade100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Opacity(
                            opacity: isUnlocked ? 1.0 : 0.4,
                            child: Text(
                              badge['icon'],
                              style: const TextStyle(fontSize: 38),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            badge['title'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: isUnlocked ? theme.colorScheme.onSurface : Colors.grey.shade600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            badge['arabicTitle'],
                            style: TextStyle(
                              fontSize: 11,
                              color: isUnlocked ? Colors.grey.shade600 : Colors.grey.shade500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: isUnlocked ? Colors.amber.withValues(alpha: 0.2) : Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              isUnlocked ? '+${badge["xp"]} XP' : '${l.locked} 🔒',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: isUnlocked ? Colors.amber.shade900 : Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
