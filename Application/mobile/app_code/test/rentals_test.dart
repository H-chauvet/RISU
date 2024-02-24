import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risu/pages/rent/rental_page.dart';

import 'globals.dart';

void main() {
  group('Test RentalPage', () {
    testWidgets('Rental Page UI', (WidgetTester tester) async {
      final testPage = initPage(const RentalPage());
      await waitForLoader(tester: tester, testPage: testPage);
      BuildContext context = tester.element(find.byType(RentalPage));

      expect(find.text(AppLocalizations.of(context)!.myRents), findsOneWidget);

      expect(find.text(AppLocalizations.of(context)!.allE), findsOneWidget);
      expect(
          find.text(AppLocalizations.of(context)!.inProgress), findsOneWidget);
    });
  });

  testWidgets('Rentals, Test if buttons are clickable',
      (WidgetTester tester) async {
    final testPage = initPage(const RentalPage());
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
  });

  testWidgets('Rental 1', (WidgetTester tester) async {
    await tester.pumpWidget(initPage(const RentalPage()));

    await tester.pump();

    expect(find.byKey(const Key('rentals-list')), findsOneWidget);
  });
}
