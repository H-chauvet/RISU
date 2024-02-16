import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risu/pages/rent/return_page.dart';

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

  testWidgets(
    'Container details should not be displayed from empty id',
    (WidgetTester tester) async {
      await tester.pumpWidget(initPage(const ReturnArticlePage(rentId: -1)));

      Finder returnButton =
          find.byKey(const Key('rent_return-button-return_article'));
      expect(returnButton, findsNothing);
    },
  );
}
