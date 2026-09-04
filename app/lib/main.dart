import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'config/routes.dart';
import 'config/locale_provider.dart';
import 'theme/app_theme.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Init local storage (settings + cache live here).
  await Hive.initFlutter();
  final settingsBox = await Hive.openBox('app_settings');

  runApp(
    ProviderScope(
      overrides: [
        settingsBoxProvider.overrideWithValue(settingsBox),
      ],
      child: const MissonApp(),
    ),
  );
}

class MissonApp extends ConsumerWidget {
  const MissonApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final locale = ref.watch(localeProvider);
    final isArabic = locale.languageCode == 'ar';

    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appName,
      theme: AppTheme.lightTheme(context, isArabic: isArabic),
      darkTheme: AppTheme.darkTheme(context, isArabic: isArabic),
      themeMode: ThemeMode.light,
      routerConfig: router,
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
    );
  }
}
