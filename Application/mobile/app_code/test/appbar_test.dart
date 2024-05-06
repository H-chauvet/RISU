import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risu/components/appbar.dart';

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

  group('AppBar integration test', () {
    testWidgets('AppBar should display and handle taps',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        initPage(
          Scaffold(
            appBar: MyAppBar(
              curveColor: Colors.blue,
              showBackButton: true,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final Finder backButtonFinder =
          find.byKey(const Key('appbar-button_back'));
      final Finder logoFinder = find.byKey(const Key('appbar-image_logo'));

      // Verify that the back button is present.
      expect(backButtonFinder, findsOneWidget);
      expect(logoFinder, findsOneWidget);

      await tester.tap(backButtonFinder);
      await tester.pumpAndSettle();
    });

    testWidgets('AppBar should display title', (WidgetTester tester) async {
      await tester.pumpWidget(
        initPage(
          Scaffold(
            appBar: MyAppBar(
              curveColor: Colors.blue,
              textTitle: "Test Title",
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final Finder appBarTitleData = find.byKey(const Key('appbar-text_title'));

      // Verify that the back button is present.
      expect(appBarTitleData, findsOneWidget);

      await tester.pumpAndSettle();
    });
  });
}
