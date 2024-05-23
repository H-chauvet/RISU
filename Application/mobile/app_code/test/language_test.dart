import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:risu/utils/providers/language.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('LanguageProvider', () {
    test('changes language to new locale', () async {
      SharedPreferences.setMockInitialValues({'language': 'en'});
      final provider = LanguageProvider(const Locale('en'));

      provider.changeLanguage(const Locale('fr'));

      expect(provider.currentLocale, const Locale('fr'));
    });

    test('keeps current locale when changing to same locale', () async {
      SharedPreferences.setMockInitialValues({'language': 'en'});
      final provider = LanguageProvider(const Locale('en'));

      provider.changeLanguage(const Locale('en'));

      expect(provider.currentLocale, const Locale('en'));
    });
  });
}
