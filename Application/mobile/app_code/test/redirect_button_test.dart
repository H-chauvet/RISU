import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risu/components/parameter.dart';
import 'package:risu/globals.dart';
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

  testWidgets('Disconnect Working button with null data',
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
                  MyRedirectDivider(
                      title: 'TestButton',
                      goToPage: LoginPage(),
                      paramIcon: Icon(Icons.abc),
                      disconnect: true),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    Finder testButton = find.byType(MyRedirectDivider);
    expect(testButton, findsOneWidget);

    await tester.tap(find.text('TestButton'));
    await tester.pump();
  });

  testWidgets('Disconnect Working button with data',
      (WidgetTester tester) async {
    userInformation = initExampleUser();
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
                  MyRedirectDivider(
                      title: 'TestButton',
                      goToPage: LoginPage(),
                      paramIcon: Icon(Icons.abc),
                      disconnect: true),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    Finder testButton = find.byType(MyRedirectDivider);
    expect(testButton, findsOneWidget);

    await tester.tap(find.text('TestButton'));
    await tester.pump();
  });

  testWidgets('Working button bottom divider with null user infos',
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
                  MyRedirectDivider(
                    title: 'TestButton',
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

    Finder testButton = find.byType(MyRedirectDivider);
    expect(testButton, findsOneWidget);

    await tester.tap(find.text('TestButton'));
    await tester.pump();
  });

  testWidgets('Working button bottom divider with user info',
      (WidgetTester tester) async {
    userInformation = initExampleUser();
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
                  MyRedirectDivider(
                    title: 'TestButton',
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

    Finder testButton = find.byType(MyRedirectDivider);
    expect(testButton, findsOneWidget);

    await tester.tap(find.text('TestButton'));
    await tester.pump();
  });

  testWidgets('Working button bottom divider', (WidgetTester tester) async {
    userInformation = initExampleUser();
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
                  MyRedirectDivider(
                    title: 'TestButton',
                    goToPage: LoginPage(),
                    paramIcon: Icon(Icons.abc),
                    chosenPlace: DIVIDERPLACE.top,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    Finder testButton = find.byType(MyRedirectDivider);
    expect(testButton, findsOneWidget);

    await tester.tap(find.text('TestButton'));
    await tester.pump();
  });
}
