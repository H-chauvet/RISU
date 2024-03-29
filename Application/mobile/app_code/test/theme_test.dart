import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:risu/utils/providers/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'globals.dart';

void main() {
  group('ThemeProvider Integration Test', () {
    setUpAll(() async {
      // This code runs once before all the tests.
      WidgetsFlutterBinding.ensureInitialized();
      WidgetController.hitTestWarningShouldBeFatal = true;
    });

    tearDown(() {
      // This code runs after each test case.
    });

    testWidgets('Toggle theme and save to SharedPreferences', (tester) async {
      SharedPreferences.setMockInitialValues({'appTheme': appTheme['clair']});

      await tester.pumpWidget(initPage(
        Consumer<ThemeProvider>(
          builder: (_, themeProvider, __) {
            return MaterialApp(
              theme: themeProvider.currentTheme,
              home: Scaffold(
                body: TextButton(
                  onPressed: () {
                    themeProvider.setTheme(appTheme['sombre']);
                  },
                  child: const Text('dark Theme'),
                ),
              ),
            );
          },
        ),
      ));

      expect(Theme.of(tester.element(find.byType(TextButton))).brightness,
          Brightness.light);

      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();

      expect(Theme.of(tester.element(find.byType(TextButton))).brightness,
          Brightness.dark);

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('appTheme'), appTheme['sombre']);
    });
  });

  testWidgets('Toggle theme and save to SharedPreferences', (tester) async {
    SharedPreferences.setMockInitialValues({'appTheme': appTheme['clair']});

    await tester.pumpWidget(initPage(
      Consumer<ThemeProvider>(
        builder: (_, themeProvider, __) {
          return MaterialApp(
            theme: themeProvider.currentTheme,
            home: Scaffold(
              body: TextButton(
                onPressed: () {
                  themeProvider.setTheme(appTheme['systeme']);
                },
                child: const Text('system Theme'),
              ),
            ),
          );
        },
      ),
      appTheme: 'clair',
    ));

    expect(Theme.of(tester.element(find.byType(TextButton))).brightness,
        Brightness.light);

    await tester.tap(find.byType(TextButton));
    await tester.pumpAndSettle();

    expect(Theme.of(tester.element(find.byType(TextButton))).brightness,
        Brightness.light);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('appTheme'), appTheme['systeme']);
  });
}
