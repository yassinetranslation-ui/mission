import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../config/dependency_injection.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_card.dart';

class ParentSettingsScreen extends ConsumerStatefulWidget {
  const ParentSettingsScreen({super.key});

  @override
  ConsumerState<ParentSettingsScreen> createState() => _ParentSettingsScreenState();
}

class _ParentSettingsScreenState extends ConsumerState<ParentSettingsScreen> {
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'العربية (Arabic)';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authRepo = ref.watch(authRepositoryProvider);
    final user = authRepo.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings & Profile'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            // Account Card
            AppCard.elevated(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.15),
                    child: Text(
                      user?.name.isNotEmpty == true ? user!.name[0].toUpperCase() : 'P',
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
                          user?.name ?? 'Parent User',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user?.email ?? 'parent@example.com',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade100,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            '🌟 Misson Plus Plan',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.amber,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Preferences
            Text(
              'App Preferences',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),

            AppCard(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.language),
                    title: const Text('Language / اللغة'),
                    subtitle: Text(_selectedLanguage),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (c) => SafeArea(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                title: const Text('العربية (Arabic)'),
                                trailing: _selectedLanguage.contains('Arabic') ? const Icon(Icons.check, color: Colors.green) : null,
                                onTap: () {
                                  setState(() => _selectedLanguage = 'العربية (Arabic)');
                                  Navigator.pop(c);
                                },
                              ),
                              ListTile(
                                title: const Text('English'),
                                trailing: _selectedLanguage == 'English' ? const Icon(Icons.check, color: Colors.green) : null,
                                onTap: () {
                                  setState(() => _selectedLanguage = 'English');
                                  Navigator.pop(c);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    secondary: const Icon(Icons.notifications_outlined),
                    title: const Text('Study Reminders & Streaks'),
                    subtitle: const Text('Notify when streak is at risk'),
                    value: _notificationsEnabled,
                    onChanged: (val) => setState(() => _notificationsEnabled = val),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.cleaning_services_outlined),
                    title: const Text('Offline Games Cache'),
                    subtitle: const Text('Clear cached missions'),
                    trailing: const Text('Clear', style: TextStyle(color: Colors.blue)),
                    onTap: () async {
                      final messenger = ScaffoldMessenger.of(context);
                      final cache = ref.read(localCacheProvider);
                      await cache.clearCache();
                      if (mounted) {
                        messenger.showSnackBar(
                          const SnackBar(content: Text('Offline game cache cleared successfully.')),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Experience Switcher
            Text(
              'Modes & Navigation',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),

            AppCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.sports_esports, color: Color(0xFFFF6B35)),
                    title: const Text('Switch to Child Game Hub'),
                    subtitle: const Text('Open gamified kid experience'),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () => context.go('/child'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Logout Button
            AppButton.secondary(
              label: 'Log Out',
              icon: Icons.logout,
              onPressed: () async {
                final router = GoRouter.of(context);
                final authNotifier = ref.read(authProvider.notifier);
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (c) => AlertDialog(
                    title: const Text('Log Out'),
                    content: const Text('Are you sure you want to log out?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
                      TextButton(
                        onPressed: () => Navigator.pop(c, true),
                        style: TextButton.styleFrom(foregroundColor: Colors.red),
                        child: const Text('Log Out'),
                      ),
                    ],
                  ),
                );

                if (confirm == true && mounted) {
                  await authNotifier.logout();
                  if (mounted) router.go('/login');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
