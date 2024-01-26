import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risu/components/parameter.dart';
import 'package:risu/pages/login/login_page.dart';

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
}
