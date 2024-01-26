import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risu/components/parameter.dart';
import 'package:risu/pages/login/login_page.dart';
import 'package:risu/pages/settings/settings_pages/theme/theme_settings_page.dart';
import 'package:provider/provider.dart';
import 'package:risu/utils/theme.dart';

import 'globals.dart';

void main() {
  setUpAll(() async {
    // This code runs once before all the tests.
    WidgetsFlutterBinding.ensureInitialized();
    WidgetController.hitTestWarningShouldBeFatal = true;
  });

  tearDown(() {
    // This code runs after each test case.
  });

  testWidgets('Non Working button', (WidgetTester tester) async {
    await tester.pumpWidget(
      initPage(
        Scaffold(
          resizeToAvoidBottomInset: true,
          body: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: const Column(
                children: [
                  SizedBox(height: 100),
                  MyParameter(
                      title: "TestButton",
                      goToPage: LoginPage(),
                      paramIcon: Icon(Icons.abc),
                      locked: true),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    Finder testButton = find.byType(MyParameter);
    expect(testButton, findsOneWidget);

    await tester.tap(find.text('TestButton'));
    await tester.pump();

    Finder newTestButton = find.byType(MyParameter);
    expect(newTestButton, findsOneWidget);
  });

  testWidgets('Working button', (WidgetTester tester) async {
    await tester.pumpWidget(
      initPage(
        Scaffold(
          resizeToAvoidBottomInset: true,
          body: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: const Column(
                children: [
                  SizedBox(height: 100),
                  MyParameter(
                    title: "TestButton",
                    goToPage: LoginPage(),
                    paramIcon: Icon(Icons.abc),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    Finder testButton = find.byType(MyParameter);
    expect(testButton, findsOneWidget);

    await tester.tap(find.text('TestButton'));
    await tester.pump();
  });

  testWidgets('my parameter modal select light theme',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      initPage(
        Scaffold(
          resizeToAvoidBottomInset: true,
          body: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: const Column(
                children: [
                  SizedBox(height: 100),
                  MyParameterModal(
                    title: "theme",
                    modalContent: ThemeChangeModalContent(),
                    paramIcon: Icon(Icons.abc),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    Finder testButton = find.byType(MyParameterModal);
    expect(testButton, findsOneWidget);

    await tester.tap(find.text('theme'));
    await tester.pump();
    await find.text('Theme');
    await tester.pumpAndSettle();
  });
}

// theme_settings_page.dart
/*import 'package:flutter/material.dart';
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
}*/
