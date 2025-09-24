import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  Locale _locale = const Locale('de'); // German as default
  Locale get locale => _locale;

  LanguageProvider() {
    // Load the saved language preference when provider is initialized
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString('language_code');
    if (savedLanguage != null) {
      _locale = Locale(savedLanguage);
      notifyListeners();
    }
  }

  Future<void> changeLanguage(Locale locale) async {
    if (!['en', 'de'].contains(locale.languageCode)) return;

    _locale = locale;

    // Save the selected language preference
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);

    notifyListeners();
  }

  String get currentLanguageFlag {
    return _locale.languageCode == 'de'
        ? 'assets/images/header/german_flag_icon.svg'
        : 'assets/images/header/united_kingdom_flag_icon.svg';
  }

  String get oppositeLanguageFlag {
    return _locale.languageCode == 'de'
        ? 'assets/images/header/united_kingdom_flag_icon.svg'
        : 'assets/images/header/german_flag_icon.svg';
  }

  Locale get oppositeLocale {
    return _locale.languageCode == 'de'
        ? const Locale('en')
        : const Locale('de');
  }
}
