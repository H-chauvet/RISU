import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risu/globals.dart';
import 'package:risu/pages/article/article_list_data.dart';
import 'package:risu/pages/rent/rent_page.dart';

import 'globals.dart';

void main() {
  group('Test RentArticlePage', () {
    testWidgets('Rent Article Page UI', (WidgetTester tester) async {
      userInformation = initExampleUser();
      await tester.pumpWidget(
        initPage(
          RentArticlePage(
            articleData: ArticleData(
              available: true,
              id: 0,
              name: 'test object',
              containerId: 1,
              price: 3,
              status: Status.GOOD,
              categories: [],
              imagesUrl: [],
            ),
          ),
        ),
      );
      BuildContext context = tester.element(find.byType(RentArticlePage));

      // Replace these keys with the actual keys used in your RentArticlePage UI

      Finder appBarTitleData = find.byKey(const Key('appbar-text_title'));
      Finder confirmButtonFinder = find.byKey(const Key('confirm-rent-button'));
      Finder incrementButtonFinder =
          find.byKey(const Key('increment-hours-button'));
      Finder decrementButtonFinder =
          find.byKey(const Key('decrement-hours-button'));

      // Verify the initial state
      expect(appBarTitleData, findsOneWidget);
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
      await tester.pumpAndSettle();

      Finder alertDialog = find.byKey(const Key('alert_dialog_confirm_rent'));
      expect(alertDialog, findsOneWidget);

      Finder confirmButton = find.byKey(const Key('alertdialog-button_ok'));
      expect(confirmButton, findsOneWidget);

      await tester.tap(confirmButton);
      await tester.pumpAndSettle();
    });
  });
}
