import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risu/pages/rent/my_rents/rental_page.dart';

import 'globals.dart';

void main() {
  group('Test RentalPage', () {
    testWidgets('Rental Page UI', (WidgetTester tester) async {
      final testPage = initPage(
        const RentalPage(
          testRentals: [
            {
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
          ],
        ),
      );
      await waitForLoader(tester: tester, testPage: testPage);
      BuildContext context = tester.element(find.byType(RentalPage));
      final Finder appBarTitleData = find.byKey(const Key(
        'appbar-text_title',
      ));

      // Verify that the back button is present.
      expect(appBarTitleData, findsOneWidget);

      expect(find.text(AppLocalizations.of(context)!.myRents), findsOneWidget);

      expect(find.text(AppLocalizations.of(context)!.allE), findsOneWidget);
      expect(
          find.text(AppLocalizations.of(context)!.inProgress), findsOneWidget);
    });
  });

  testWidgets('Rentals, Test if buttons are clickable',
      (WidgetTester tester) async {
    final testPage = initPage(
      const RentalPage(
        testRentals: [
          {
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
        ],
      ),
    );
    await waitForLoader(tester: tester, testPage: testPage);
    BuildContext context = tester.element(find.byType(RentalPage));

    expect(find.text(AppLocalizations.of(context)!.allE), findsOneWidget);
    expect(find.text(AppLocalizations.of(context)!.inProgress), findsOneWidget);

    await tester.tap(find.text(AppLocalizations.of(context)!.allE));
    await tester.pump();

    expect(find.text(AppLocalizations.of(context)!.allE), findsOneWidget);
    expect(find.text(AppLocalizations.of(context)!.inProgress), findsOneWidget);

    await tester.tap(find.text(AppLocalizations.of(context)!.inProgress));
    await tester.pump();

    expect(find.text(AppLocalizations.of(context)!.allE), findsOneWidget);
    expect(find.text(AppLocalizations.of(context)!.inProgress), findsOneWidget);

    // expect(find.byKey(const Key('rental-list-time')), findsOneWidget);
    expect(find.byKey(const Key('rentals-list')), findsOneWidget);

    await tester.tap(find.byKey(const Key('rentals-list')));
    await tester.pump();
  });

  testWidgets('Rental 1', (WidgetTester tester) async {
    await tester.pumpWidget(initPage(const RentalPage(
      testRentals: [
        {
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
      ],
    )));

    await tester.pump();
  });
}
