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

  testWidgets('AppBar should display and handle taps',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      initPage(
        Scaffold(
          appBar: MyAppBar(
            curveColor: Colors.blue,
            showBackButton: true,
            showLogo: true,
            showBurgerMenu: true,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final Finder backButtonFinder = find.byKey(const Key('appbar-button_back'));
    final Finder logoFinder = find.byKey(const Key('appbar-image_logo'));
    final Finder burgerMenuFinder =
        find.byKey(const Key('appbar-button_burgermenu'));

    // Verify that the back button is present.
    expect(backButtonFinder, findsOneWidget);
    expect(logoFinder, findsOneWidget);
    expect(burgerMenuFinder, findsOneWidget);

    await tester.tap(burgerMenuFinder);
    await tester.pumpAndSettle();

    await tester.tap(backButtonFinder);
    await tester.pumpAndSettle();
  });
}
