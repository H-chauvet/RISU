import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risu/pages/article/article_list_data.dart';
import 'package:risu/pages/rent/confirm/confirm_rent_page.dart';

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

  testWidgets('Confirm rent test', (WidgetTester tester) async {
    final ArticleData data = ArticleData(
        id: 0, containerId: 1, name: 'Ballon', available: true, price: 8,
        );
    await tester.pumpWidget(initPage(ConfirmRentPage(hours: 5, data: data)));
    Finder homeButton = find.byKey(const Key('confirm_rent-button-back_home'));
    expect(homeButton, findsOneWidget);

    await tester.tap(homeButton);
    await tester.pumpAndSettle();
  });
}
