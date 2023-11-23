import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:risu/pages/settings/settings_page.dart';
import 'package:risu/utils/theme.dart';

void main() {
  group('Test Settings', () {
    setUpAll(() async {
      // This code runs once before all the tests.
      WidgetsFlutterBinding.ensureInitialized();
      WidgetController.hitTestWarningShouldBeFatal = true;
    });

    tearDown(() {
      // This code runs after each test case.
    });

    testWidgets('Light mode', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<ThemeProvider>(
              create: (_) => ThemeProvider(false),
            ),
          ],
          child: const MaterialApp(
            home: SettingsPage(),
          ),
        ),
      );

      final changeInformationButtonFinder =
          find.byKey(const Key('settings-button_change_information'));
      final dropdownFinder = find.byKey(const Key('drop_down'));

      final themeProvider = Provider.of<ThemeProvider>(
          tester.element(find.byType(SettingsPage)),
          listen: false);

      expect(themeProvider.currentTheme.brightness, Brightness.light);
      expect(dropdownFinder, findsOneWidget);
      expect(changeInformationButtonFinder, findsOneWidget);
      await tester.pumpAndSettle();
      await tester.tap(changeInformationButtonFinder);
      await tester.pumpAndSettle();
    });
    testWidgets('Dark mode', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<ThemeProvider>(
              create: (_) => ThemeProvider(true),
            ),
          ],
          child: const MaterialApp(
            home: SettingsPage(),
          ),
        ),
      );

      final changeInformationButtonFinder =
          find.byKey(const Key('settings-button_change_information'));
      final dropdownFinder = find.byKey(const Key('drop_down'));

      final themeProvider = Provider.of<ThemeProvider>(
          tester.element(find.byType(SettingsPage)),
          listen: false);

      expect(themeProvider.currentTheme.brightness, Brightness.dark);
      expect(dropdownFinder, findsOneWidget);
      expect(changeInformationButtonFinder, findsOneWidget);
      await tester.pumpAndSettle();
      await tester.tap(changeInformationButtonFinder);
      await tester.pumpAndSettle();
    });
  });
}
