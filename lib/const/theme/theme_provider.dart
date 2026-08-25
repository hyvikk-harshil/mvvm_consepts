import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = "is_dark_mode";
  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  ThemeProvider(){
    _loadThemeFromPref();
  }

  Future<void> _loadThemeFromPref()async {
    final pref = await SharedPreferences.getInstance();
    final isDark = pref.getBool(_themeKey) ?? false;
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  Future<void> toggleTheme()async {
    final pref = await SharedPreferences.getInstance();
    if(_themeMode == ThemeMode.light){
      _themeMode = ThemeMode.dark;
      await pref.setBool(_themeKey, true);
    }
    else
    {
      _themeMode = ThemeMode.light;
      pref.setBool(_themeKey, false);
    }
    notifyListeners();
  }
}
