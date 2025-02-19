import 'package:shared_preferences/shared_preferences.dart';

class ThemePrefs{
  static const String key = "isDarkTheme";

  static Future<void> saveTheme(bool isDark) async{
    final pref = await SharedPreferences.getInstance();
    await pref.setBool(key, isDark);
  }

  static Future<bool> getTheme() async{
    final pref = await SharedPreferences.getInstance();
    return pref.getBool(key) ?? false;
  }
}
