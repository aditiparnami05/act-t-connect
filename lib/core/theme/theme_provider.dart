import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_theme.dart';

const _themeKey = 'theme_mode';

/// Manages light/dark theme preference with persistence.
class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.light) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt(_themeKey);
    if (index != null) {
      state = ThemeMode.values[index];
    }
  }

  Future<void> setTheme(ThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, mode.index);
  }

  void toggle() {
    setTheme(state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
  }
}

final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

final appThemeDataProvider = Provider<ThemeData>((ref) {
  final mode = ref.watch(themeModeProvider);
  return mode == ThemeMode.dark ? AppTheme.dark() : AppTheme.light();
});

final isDarkModeProvider = Provider<bool>((ref) {
  return ref.watch(themeModeProvider) == ThemeMode.dark;
});
