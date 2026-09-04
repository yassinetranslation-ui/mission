import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../config/dependency_injection.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/child_profile.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/streak_badge.dart';

class ParentHomeScreen extends ConsumerStatefulWidget {
  const ParentHomeScreen({super.key});

  @override
  ConsumerState<ParentHomeScreen> createState() => _ParentHomeScreenState();
}

class _ParentHomeScreenState extends ConsumerState<ParentHomeScreen> {
  List<ChildProfile> _children = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadChildren();
  }

  Future<void> _loadChildren() async {
    setState(() => _isLoading = true);
    try {
      final repository = ref.read(childRepositoryProvider);
      final children = await repository.getChildren(forceRefresh: true);
      if (mounted) {
        setState(() {
          _children = children;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;
    final authRepo = ref.watch(authRepositoryProvider);
    final parentName = authRepo.currentUser?.name ?? l.parent;

    return Scaffold(
      appBar: AppBar(
        title: Text(l.welcomeUser(parentName)),
        actions: [
          IconButton(
            icon: const Icon(Icons.child_care),
            tooltip: l.childMode,
            onPressed: () => context.go('/child'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: l.logout,
            onPressed: () async {
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) context.go('/login');
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadChildren,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Action Card: Turn Lesson Into Game
              AppCard(
                gradient: AppColors.primaryGradient,
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.auto_awesome,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l.turnLessonIntoGame,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                l.uploadHomeSubtitle,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    AppButton.game(
                      label: '🚀 ${l.uploadNewLesson}',
                      onPressed: () => context.go('/parent/upload'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Children Section Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l.childrenProfiles,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.add, size: 18),
                    label: Text(l.addChild),
                    onPressed: () async {
                      await context.push('/parent/children/add');
                      _loadChildren();
                    },
                  ),
                ],
              ),

              const SizedBox(height: 12),

              if (_isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (_children.isEmpty)
                AppCard.outlined(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.family_restroom,
                          size: 48,
                          color: theme.colorScheme.primary.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          l.noChildrenYet,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l.addChildDesc,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        AppButton.primary(
                          label: l.addFirstChild,
                          onPressed: () async {
                            await context.push('/parent/children/add');
                            _loadChildren();
                          },
                        ),
                      ],
                    ),
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _children.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final child = _children[index];
                    return AppCard.elevated(
                      onTap: () => context.push('/parent/children/${child.id}'),
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.15),
                            child: Text(
                              child.name.isNotEmpty ? child.name[0].toUpperCase() : 'C',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  child.name,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${l.ageLabel(child.age)} • ${child.gradeLevel ?? "${l.level} ${child.currentLevel}"}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          StreakBadge(streak: child.currentStreak),
                          const SizedBox(width: 8),
                          const Icon(Icons.chevron_right),
                        ],
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
