import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class SettingsProvider with ChangeNotifier {
  late SharedPreferences _prefs;
  Locale _locale;
  ThemeMode _themeMode;

  SettingsProvider() :
        _locale = const Locale('en'),
        _themeMode = ThemeMode.system {
    _loadSettings();
  }

  Locale get locale => _locale;
  ThemeMode get themeMode => _themeMode;

  Future<void> _loadSettings() async {
    _prefs = await SharedPreferences.getInstance();
    _locale = Locale(_prefs.getString('language') ?? 'en');
    _themeMode = ThemeMode.values[_prefs.getInt('theme_mode') ?? 0];
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    await _prefs.setString('language', locale.languageCode);
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _prefs.setInt('theme_mode', mode.index);
    notifyListeners();
  }
}