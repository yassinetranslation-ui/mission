import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../config/dependency_injection.dart';
import '../../../models/child_profile.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/empty_state.dart';
import '../../../widgets/streak_badge.dart';
import '../../../widgets/xp_bar.dart';

class ChildrenListScreen extends ConsumerStatefulWidget {
  const ChildrenListScreen({super.key});

  @override
  ConsumerState<ChildrenListScreen> createState() => _ChildrenListScreenState();
}

class _ChildrenListScreenState extends ConsumerState<ChildrenListScreen> {
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Children'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await context.push('/parent/children/add');
          _loadChildren();
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Child'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadChildren,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _children.isEmpty
                ? EmptyState(
                    icon: Icons.people_outline,
                    title: 'No Children Profiles',
                    description: 'Add a child profile to track their progress and create games.',
                    buttonLabel: 'Add Child',
                    onAction: () async {
                      await context.push('/parent/children/add');
                      _loadChildren();
                    },
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(20),
                    itemCount: _children.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final child = _children[index];
                      return AppCard.elevated(
                        onTap: () async {
                          await context.push('/parent/children/${child.id}');
                          _loadChildren();
                        },
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 30,
                                  backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.15),
                                  child: Text(
                                    child.name.isNotEmpty ? child.name[0].toUpperCase() : 'C',
                                    style: TextStyle(
                                      fontSize: 24,
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
                                        style: theme.textTheme.titleLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Age: ${child.age}  •  Grade: ${child.gradeLevel ?? "N/A"}',
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          color: theme.colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                StreakBadge(streak: child.currentStreak),
                              ],
                            ),
                            const SizedBox(height: 16),
                            XpBar(
                              currentXp: child.xpTotal % 1000,
                              nextLevelXp: 1000,
                              level: child.currentLevel,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}
