import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../config/dependency_injection.dart';
import '../../../models/child_profile.dart';
import '../../../services/child_service.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_card.dart';
import '../../../widgets/app_input.dart';
import '../../../widgets/streak_badge.dart';
import '../../../widgets/xp_bar.dart';

class ChildDetailScreen extends ConsumerStatefulWidget {
  final String childId;

  const ChildDetailScreen({required this.childId, super.key});

  @override
  ConsumerState<ChildDetailScreen> createState() => _ChildDetailScreenState();
}

class _ChildDetailScreenState extends ConsumerState<ChildDetailScreen> {
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
      final repository = ref.read(childRepositoryProvider);
      final child = await repository.getChild(widget.childId);
      if (mounted) {
        setState(() {
          _child = child;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _showEditDialog() async {
    if (_child == null) return;

    final nameController = TextEditingController(text: _child!.name);
    final ageController = TextEditingController(text: _child!.age.toString());
    String selectedGrade = _child!.gradeLevel ?? '1st Grade';

    final grades = [
      'Pre-K',
      'Kindergarten',
      '1st Grade',
      '2nd Grade',
      '3rd Grade',
      '4th Grade',
      '5th Grade',
      '6th Grade',
    ];

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Child Profile'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppInput(
                  controller: nameController,
                  label: 'Name',
                  hint: 'Child\'s name',
                ),
                const SizedBox(height: 16),
                AppInput(
                  controller: ageController,
                  label: 'Age',
                  hint: 'Child\'s age',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: grades.contains(selectedGrade) ? selectedGrade : grades[0],
                  decoration: const InputDecoration(labelText: 'Grade Level'),
                  items: grades.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                  onChanged: (val) {
                    if (val != null) selectedGrade = val;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            AppButton.primary(
              label: 'Save',
              size: AppButtonSize.sm,
              onPressed: () async {
                final newAge = int.tryParse(ageController.text) ?? _child!.age;
                final repo = ref.read(childRepositoryProvider);
                final navigator = Navigator.of(context);
                final messenger = ScaffoldMessenger.of(context);
                
                try {
                  await repo.updateChild(
                    _child!.id,
                    UpdateChildRequest(
                      name: nameController.text.trim(),
                      age: newAge,
                      gradeLevel: selectedGrade,
                    ),
                  );
                  navigator.pop();
                  _loadChild();
                } catch (e) {
                  messenger.showSnackBar(
                    SnackBar(content: Text('Failed to update child: $e')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteChild() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Profile'),
        content: Text('Are you sure you want to delete ${_child?.name}\'s profile? This will remove all their progress.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      final repo = ref.read(childRepositoryProvider);
      final router = GoRouter.of(context);
      final messenger = ScaffoldMessenger.of(context);
      
      try {
        await repo.deleteChild(widget.childId);
        router.pop();
      } catch (e) {
        messenger.showSnackBar(
          SnackBar(content: Text('Failed to delete child: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Child Details')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_child == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Child Details')),
        body: const Center(child: Text('Child profile not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_child!.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Edit Profile',
            onPressed: _showEditDialog,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            tooltip: 'Delete Profile',
            onPressed: _deleteChild,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile Header Card
            AppCard.elevated(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.15),
                    child: Text(
                      _child!.name.isNotEmpty ? _child!.name[0].toUpperCase() : 'C',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _child!.name,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Age ${_child!.age}  •  ${_child!.gradeLevel ?? "Grade N/A"}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  StreakBadge(streak: _child!.currentStreak),
                  const SizedBox(height: 20),
                  XpBar(
                    currentXp: _child!.xpTotal % 1000,
                    nextLevelXp: 1000,
                    level: _child!.currentLevel,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Actions Card
            AppCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Actions',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  AppButton.game(
                    label: '🎮 Play as ${_child!.name}',
                    onPressed: () => context.go('/child'),
                  ),
                  const SizedBox(height: 12),
                  AppButton.secondary(
                    label: '📊 View Progress & Reports',
                    onPressed: () => context.push('/parent/reports/${_child!.id}'),
                  ),
                  const SizedBox(height: 12),
                  AppButton.primary(
                    label: '📤 Upload Lesson for ${_child!.name}',
                    onPressed: () => context.push('/parent/upload'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
