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

  testWidgets('Get invoice in confirm rent', (WidgetTester tester) async {
    final ArticleData data = ArticleData(
      id: 0,
      containerId: 1,
      name: 'Ballon',
      available: true,
      status: Status.GOOD,
      price: 8,
      categories: [],
    );
    await tester.pumpWidget(initPage(ConfirmRentPage(
      hours: 5,
      data: data,
      startDate: null,
      locationId: 1,
    )));
    Finder invoiceButton =
        find.byKey(const Key('return_rent-button-receive_invoice'));

    await tester.scrollUntilVisible(invoiceButton, 100);
    await tester.tap(invoiceButton);
    await tester.pumpAndSettle();
  });
}
