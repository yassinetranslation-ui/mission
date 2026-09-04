import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

/// Box that holds lightweight app settings (locale, theme mode, ...).
/// Overridden in `main()` once Hive is initialized.
final settingsBoxProvider = Provider<Box>((ref) {
  throw UnimplementedError('settingsBoxProvider must be overridden in main()');
});

/// Current app locale, persisted across launches. Defaults to Arabic.
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier(ref.watch(settingsBoxProvider));
});

class LocaleNotifier extends StateNotifier<Locale> {
  final Box _box;
  static const String _key = 'locale_code';
  static const String defaultCode = 'ar';

  LocaleNotifier(this._box)
      : super(Locale(_box.get(_key, defaultValue: defaultCode) as String));

  bool get isArabic => state.languageCode == 'ar';

  void setLocale(String code) {
    if (code != 'ar' && code != 'en') return;
    _box.put(_key, code);
    state = Locale(code);
  }

  void toggle() => setLocale(isArabic ? 'en' : 'ar');
}
