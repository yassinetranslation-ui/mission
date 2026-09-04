import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../auth/providers/auth_provider.dart';
import '../../../config/dependency_injection.dart';
import '../../../config/locale_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../theme/app_colors.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/app_card.dart';

class ParentSettingsScreen extends ConsumerStatefulWidget {
  const ParentSettingsScreen({super.key});

  @override
  ConsumerState<ParentSettingsScreen> createState() => _ParentSettingsScreenState();
}

class _ParentSettingsScreenState extends ConsumerState<ParentSettingsScreen> {
  bool _notificationsEnabled = true;

  void _showLanguageSheet(AppLocalizations l) {
    final current = ref.read(localeProvider).languageCode;
    showModalBottomSheet(
      context: context,
      builder: (c) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            ListTile(
              title: Text(l.arabic),
              trailing: current == 'ar' ? const Icon(Icons.check, color: AppColors.success) : null,
              onTap: () {
                ref.read(localeProvider.notifier).setLocale('ar');
                Navigator.pop(c);
              },
            ),
            ListTile(
              title: Text(l.english),
              trailing: current == 'en' ? const Icon(Icons.check, color: AppColors.success) : null,
              onTap: () {
                ref.read(localeProvider.notifier).setLocale('en');
                Navigator.pop(c);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = AppLocalizations.of(context)!;
    final authRepo = ref.watch(authRepositoryProvider);
    final user = authRepo.currentUser;
    final isArabic = ref.watch(localeProvider).languageCode == 'ar';

    return Scaffold(
      appBar: AppBar(
        title: Text(l.settingsAndProfile),
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
                          user?.name ?? l.parent,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user?.email ?? '',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
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
              l.appPreferences,
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
                    title: Text(l.language),
                    subtitle: Text(isArabic ? l.arabic : l.english),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showLanguageSheet(l),
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    secondary: const Icon(Icons.notifications_outlined),
                    title: Text(l.studyReminders),
                    subtitle: Text(l.studyRemindersDesc),
                    value: _notificationsEnabled,
                    onChanged: (val) => setState(() => _notificationsEnabled = val),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.cleaning_services_outlined),
                    title: Text(l.offlineCache),
                    subtitle: Text(l.offlineCacheDesc),
                    trailing: Text(l.clear, style: const TextStyle(color: AppColors.primary)),
                    onTap: () async {
                      final messenger = ScaffoldMessenger.of(context);
                      final cache = ref.read(localCacheProvider);
                      await cache.clearCache();
                      if (mounted) {
                        messenger.showSnackBar(
                          SnackBar(content: Text(l.cacheCleared)),
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
              l.modesNavigation,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 12),

            AppCard(
              padding: const EdgeInsets.all(16),
              child: ListTile(
                leading: const Icon(Icons.sports_esports, color: AppColors.childPrimary),
                title: Text(l.switchToChildHub),
                subtitle: Text(l.switchToChildHubDesc),
                trailing: const Icon(Icons.arrow_forward),
                onTap: () => context.go('/child'),
              ),
            ),

            const SizedBox(height: 32),

            // Logout Button
            AppButton.secondary(
              label: l.logOut,
              icon: Icons.logout,
              onPressed: () async {
                final router = GoRouter.of(context);
                final authNotifier = ref.read(authProvider.notifier);
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (c) => AlertDialog(
                    title: Text(l.logOut),
                    content: Text(l.logoutConfirm),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(c, false), child: Text(l.cancel)),
                      TextButton(
                        onPressed: () => Navigator.pop(c, true),
                        style: TextButton.styleFrom(foregroundColor: AppColors.error),
                        child: Text(l.logOut),
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
