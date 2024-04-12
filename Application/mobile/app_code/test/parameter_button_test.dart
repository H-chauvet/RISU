import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risu/components/parameter.dart';
import 'package:risu/pages/login/login_page.dart';
import 'package:risu/pages/settings/settings_pages/theme/theme_settings_page.dart';

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
                      title: 'TestButton',
                      goToPage: LoginPage(),
                      pageName: LoginPage.routeName,
                      paramIcon: Icons.abc,
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
                    title: 'TestButton',
                    goToPage: LoginPage(),
                    pageName: LoginPage.routeName,
                    paramIcon: Icons.abc,
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
                    title: 'theme',
                    modalContent: ThemeChangeModalContent(),
                    paramIcon: Icons.abc,
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
