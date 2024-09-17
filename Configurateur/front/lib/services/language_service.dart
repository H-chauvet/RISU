import 'package:flutter/material.dart';
import 'package:front/services/storage_service.dart';

String defaultLanguage = 'fr';
String language = defaultLanguage;

/// LanguageService
///
/// Service to manage the language of the website
/// [language] : Country code of the language
class LanguageService extends ChangeNotifier {
  Locale _currentLocale = Locale(defaultLanguage);

  LanguageService(Locale language) {
    _currentLocale = language;
  }

  Locale get currentLocale => _currentLocale;

  void changeLanguage(Locale locale) async {
    _currentLocale = locale;
    language = locale.languageCode;
    notifyListeners();
    storageService.writeStorage('language', locale.languageCode);
  }
}
