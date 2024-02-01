import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risu/pages/rent/rental_page.dart';

import 'globals.dart';

void main() {
  group('Test RentalPage', () {
    testWidgets('Rental Page UI', (WidgetTester tester) async {
      final testPage = initPage(const RentalPage());
      await waitForLoader(tester: tester, testPage: testPage);

      expect(find.text('Mes locations'), findsOneWidget);

      expect(find.text('Toutes'), findsOneWidget);
      expect(find.text('En cours'), findsOneWidget);
    });
  });

  testWidgets('Rentals, Test if buttons are clickable',
          (WidgetTester tester) async {
        final testPage = initPage(const RentalPage());
        await waitForLoader(tester: tester, testPage: testPage);

        expect(find.text('Toutes'), findsOneWidget);
        expect(find.text('En cours'), findsOneWidget);

        await tester.tap(find.text('Toutes'));
        await tester.pump();

        expect(find.text('Toutes'), findsOneWidget);
        expect(find.text('En cours'), findsOneWidget);

        await tester.tap(find.text('En cours'));
        await tester.pump();

        expect(find.text('Toutes'), findsOneWidget);
        expect(find.text('En cours'), findsOneWidget);
      });

  testWidgets('Rental 1', (WidgetTester tester) async {
    await tester.pumpWidget(initPage(const RentalPage()));

    await tester.pump();

    expect(find.byKey(const Key('rentals-list')), findsOneWidget);
  });
}
