import 'package:flutter/material.dart';
import 'theme_prefs.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _loadTheme();
  }

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    ThemePrefs.saveTheme(isDark);
    notifyListeners();
  }

  Future<void> _loadTheme() async {
    bool isDark = await ThemePrefs.getTheme();
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
