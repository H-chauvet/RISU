import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:risu/pages/rent/rentals/rentals_list_card.dart';

import 'globals.dart';

void main() {
  group('Test RentalCard', () {
    testWidgets('Rental Card UI | in progress', (WidgetTester tester) async {
      final testPage = initPage(
        RentalCard(
          rental: {
            "id": 1,
            "price": 100,
            "createdAt": DateTime.now().toString(),
            "duration": 1,
            "ended": false,
            "item": const {
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
      );
      await waitForLoader(tester: tester, testPage: testPage);
      // BuildContext context = tester.element(find.byType(RentalCard));
      final Finder articleName = find.byKey(const Key('article_name'));
      final Finder articleTimeRemaining =
          find.byKey(const Key('article_timeRemaining'));

      expect(articleName, findsOneWidget);
      expect(articleTimeRemaining, findsOneWidget);
    });

    testWidgets('Rental Card UI | ended', (WidgetTester tester) async {
      final testPage = initPage(
        const RentalCard(
          rental: {
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
      );
      await waitForLoader(tester: tester, testPage: testPage);
      // BuildContext context = tester.element(find.byType(RentalCard));
      final Finder articleName = find.byKey(const Key('article_name'));

      expect(articleName, findsOneWidget);
    });
  });
}
