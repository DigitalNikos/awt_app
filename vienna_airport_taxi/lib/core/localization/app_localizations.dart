import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  // Helper method to keep the code in the widgets concise
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  // Static member to have a simple access to the delegate from the MaterialApp
  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  late Map<String, dynamic> _localizedStrings;

  Future<bool> load() async {
    // Load the language JSON file from the "assets/lang" folder
    String jsonString =
        await rootBundle.loadString('assets/lang/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    // Keep the nested structure instead of flattening to strings
    _localizedStrings = jsonMap;

    return true;
  }

  // This method will be called from every widget which needs a localized text
  String translate(String key) {
    try {
      // Handle nested keys with dot notation (e.g., "form.step1.date_time_section.Date_and_Time")
      List<String> keys = key.split('.');
      dynamic value = _localizedStrings;


      for (String k in keys) {
        if (value is Map && value.containsKey(k)) {
          value = value[k];
        } else {
          // Key not found in the localization map
          return key; // Return the key if path not found
        }
      }

      final result = value?.toString() ?? key;
      return result;
    } catch (e) {
      return key;
    }
  }
}

// LocalizationsDelegate is a factory for a set of localized resources
class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    // Include all of your supported language codes here
    return ['en', 'de'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    // AppLocalizations class is where the JSON loading actually runs
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
