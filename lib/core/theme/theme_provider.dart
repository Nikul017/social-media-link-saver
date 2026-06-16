import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_provider.g.dart';

enum ThemeStyle {
  classic,
  neoBrutalist,
}

// Keys for SharedPreferences
const _kThemeModeKey = 'theme_mode';
const _kThemeStyleKey = 'theme_style';

@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  @override
  ThemeMode build() {
    // Load persisted value synchronously at startup
    // We'll seed properly from SharedPreferences in initState via setTheme
    return ThemeMode.dark; // fallback until persisted value is loaded
  }

  Future<void> loadSaved() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_kThemeModeKey);
    if (saved == 'light') {
      state = ThemeMode.light;
    } else {
      state = ThemeMode.dark;
    }
  }

  void toggleTheme() {
    final next = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    state = next;
    _persist(next);
  }

  void setTheme(ThemeMode mode) {
    state = mode;
    _persist(mode);
  }

  Future<void> _persist(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kThemeModeKey, mode == ThemeMode.dark ? 'dark' : 'light');
  }
}

@riverpod
class ThemeStyleNotifier extends _$ThemeStyleNotifier {
  @override
  ThemeStyle build() {
    return ThemeStyle.classic; // fallback until persisted value is loaded
  }

  Future<void> loadSaved() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_kThemeStyleKey);
    if (saved == 'neoBrutalist') {
      state = ThemeStyle.neoBrutalist;
    } else {
      state = ThemeStyle.classic;
    }
  }

  void toggleStyle() {
    final next = state == ThemeStyle.classic ? ThemeStyle.neoBrutalist : ThemeStyle.classic;
    state = next;
    _persist(next);
  }

  void setStyle(ThemeStyle style) {
    state = style;
    _persist(style);
  }

  Future<void> _persist(ThemeStyle style) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kThemeStyleKey, style == ThemeStyle.neoBrutalist ? 'neoBrutalist' : 'classic');
  }
}
