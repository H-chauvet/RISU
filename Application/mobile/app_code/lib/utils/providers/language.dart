import 'package:flutter/cupertino.dart';
import 'package:risu/globals.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// This class is used to manage the language of the application
/// It allows to change the language of the application
class LanguageProvider extends ChangeNotifier {
  Locale _currentLocale = Locale(defaultLanguage);

  LanguageProvider(Locale language) {
    _currentLocale = language;
  }

  Locale get currentLocale => _currentLocale;

  void changeLanguage(Locale locale) async {
    _currentLocale = locale;
    language = locale.languageCode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('language', locale.languageCode);
  }
}
