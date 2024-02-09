import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risu/pages/article/article_list_data.dart';
import 'package:risu/pages/rent/rent_page.dart';

import 'globals.dart';

void main() {
  group('Test RentArticlePage', () {
    testWidgets('Rent Article Page UI', (WidgetTester tester) async {
      await tester.pumpWidget(
        initPage(
          RentArticlePage(
            articleData: ArticleData(
              available: true,
              id: '1234',
              name: 'test object',
              containerId: '12345',
              price: 3,
            ),
          ),
        ),
      );
      BuildContext context = tester.element(find.byType(RentArticlePage));

      // Replace these keys with the actual keys used in your RentArticlePage UI
      Finder confirmButtonFinder = find.byKey(const Key('confirm-rent-button'));
      Finder incrementButtonFinder =
          find.byKey(const Key('increment-hours-button'));
      Finder decrementButtonFinder =
          find.byKey(const Key('decrement-hours-button'));

      // Verify the initial state
      expect(confirmButtonFinder, findsOneWidget);
      expect(incrementButtonFinder, findsOneWidget);
      expect(decrementButtonFinder, findsOneWidget);

      // Simulate user interaction
      await tester.tap(incrementButtonFinder);
      await tester.pump();

      // Verify the updated state after interaction
      expect(find.text(AppLocalizations.of(context)!.rentHours(2)),
          findsOneWidget);

      // Simulate user interaction
      await tester.tap(decrementButtonFinder);
      await tester.pump();

      // Verify the updated state after interaction
      expect(find.text(AppLocalizations.of(context)!.rentHours(1)),
          findsOneWidget);

      // Simulate another user interaction
      await tester.scrollUntilVisible(confirmButtonFinder, 100.0);
      await tester.tap(confirmButtonFinder);
      await tester.pump();
    });
  });
}
