import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:risu/pages/settings/settings_pages/theme/theme_settings_page.dart';
import 'package:risu/utils/theme.dart';

import 'globals.dart';

void main() {
  group('Test Theme Settings', () {
    setUpAll(() async {
      // This code runs once before all the tests.
      WidgetsFlutterBinding.ensureInitialized();
      WidgetController.hitTestWarningShouldBeFatal = true;
    });

    tearDown(() {
      // This code runs after each test case.
    });

    testWidgets('Light mode', (WidgetTester tester) async {
      await tester.pumpWidget(initPage(const ThemeSettingsPage()));

      final dropdownFinder = find.byKey(const Key('drop_down'));

      final themeProvider = Provider.of<ThemeProvider>(
          tester.element(find.byType(ThemeSettingsPage)),
          listen: false);

      expect(themeProvider.currentTheme.brightness, Brightness.light);
      expect(dropdownFinder, findsOneWidget);
      await tester.pumpAndSettle();
    });
    testWidgets('Dark mode', (WidgetTester tester) async {
      await tester
          .pumpWidget(initPage(const ThemeSettingsPage(), isDarkMode: true));

      final dropdownFinder = find.byKey(const Key('drop_down'));

      final themeProvider = Provider.of<ThemeProvider>(
          tester.element(find.byType(ThemeSettingsPage)),
          listen: false);

      expect(themeProvider.currentTheme.brightness, Brightness.dark);
      expect(dropdownFinder, findsOneWidget);
      await tester.pumpAndSettle();
    });
  });
}
