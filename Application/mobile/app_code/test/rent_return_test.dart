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

  testWidgets("Rental with test data", (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 900));
    await tester.pumpWidget(
      initPage(
        const ReturnArticlePage(
          rentId: 1,
          testRental: {
            "id": 1,
            "price": 100,
            "createdAt": "2024-05-23T09:18:46.814Z",
            "duration": 1,
            "ended": false,
            "item": {
              "id": 3,
              "name": "Ballon de football",
              "container": {
                "id": 1,
                "address": "Rue d'Alger",
                "city": "Nantes",
              }
            }
          },
        ),
      ),
    );

    final Finder logoFinder = find.byKey(const Key('appbar-image_logo'));
    expect(logoFinder, findsOneWidget);

    Finder returnButton =
        find.byKey(const Key('rent_return-button-return_article'));
    expect(returnButton, findsOneWidget);

    await tester.tap(returnButton);
    await tester.pump();
  });

  testWidgets("Rental with test data (returned)", (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 900));
    await tester.pumpWidget(
      initPage(
        const ReturnArticlePage(
          rentId: 1,
          testRental: {
            "id": 1,
            "price": 100,
            "createdAt": "2024-05-23T09:18:46.814Z",
            "duration": 1,
            "ended": true,
            "item": {
              "id": 3,
              "name": "Ballon de football",
              "container": {
                "id": 1,
                "address": "Rue d'Alger",
                "city": "Nantes",
              }
            }
          },
        ),
      ),
    );

    final Finder logoFinder = find.byKey(const Key('appbar-image_logo'));
    expect(logoFinder, findsOneWidget);

    Finder returnButton =
        find.byKey(const Key('rent_return-button-return_article'));
    expect(returnButton, findsNothing);

    Finder invoiceButton =
        find.byKey(const Key('return_rent-button-receive_invoice'));
    expect(invoiceButton, findsOneWidget);

    Finder detailsButton =
        find.byKey(const Key('return_rent-button-go-to-details'));
    expect(detailsButton, findsOneWidget);

    await tester.tap(detailsButton);
    await tester.pump();
  });
}
