import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risu/pages/opinion/opinion_page.dart';

import 'globals.dart';

void main() {
  group('Test Opinion Page', () {
    testWidgets('find opinions pages buttons', (WidgetTester tester) async {
      final testPage = initPage(const OpinionPage(itemId: 1));
      await waitForLoader(tester: tester, testPage: testPage);
      BuildContext context = tester.element(find.byType(OpinionPage));

      Finder addOpinionButtonFinder =
          find.byKey(const Key('add_opinion-button'));
      Finder opinionButtonFilterFinder =
          find.text(AppLocalizations.of(context)!.reviewsAll);

      // Verify the initial state
      expect(addOpinionButtonFinder, findsOneWidget);
      expect(opinionButtonFilterFinder, findsOneWidget);

      Finder filterAll = find.byKey(const Key('opinion-filter_dropdown_all'));

      await tester.tap(filterAll);
      await tester.pump();

      await tester.dragUntilVisible(
          addOpinionButtonFinder, // what you want to find
          filterAll, // widget you want to scroll
          const Offset(0, -500) // delta to move
          );
    });

    testWidgets('select filter 0 stars', (WidgetTester tester) async {
      final testPage = initPage(const OpinionPage(itemId: 1));
      await waitForLoader(tester: tester, testPage: testPage);
      BuildContext context = tester.element(find.byType(OpinionPage));

      // Replace these keys with the actual keys used in your RentArticlePage UI
      Finder addOpinionButtonFinder =
          find.byKey(const Key('add_opinion-button'));
      Finder opinionButtonFilterFinder =
          find.byKey(const Key('opinion-filter_dropdown'));

      // Verify the initial state
      expect(addOpinionButtonFinder, findsOneWidget);
      expect(opinionButtonFilterFinder, findsOneWidget);

      await tester.tap(opinionButtonFilterFinder);
      await tester.pump();

      Finder filterAll = find.byKey(const Key('opinion-filter_dropdown_all'));
      await tester.tap(filterAll, warnIfMissed: false);
      await tester.pump();

      expect(
          find.text(AppLocalizations.of(context)!.starsX(0)), findsOneWidget);
      expect(
          find.text(AppLocalizations.of(context)!.starsX(1)), findsOneWidget);
      expect(
          find.text(AppLocalizations.of(context)!.starsX(2)), findsOneWidget);
      expect(
          find.text(AppLocalizations.of(context)!.starsX(3)), findsOneWidget);
      expect(
          find.text(AppLocalizations.of(context)!.starsX(4)), findsOneWidget);
      expect(
          find.text(AppLocalizations.of(context)!.starsX(5)), findsOneWidget);
      expect(find.text(AppLocalizations.of(context)!.reviewsAll),
          findsNWidgets(2));

      Finder filter_0 = find.byKey(const Key('opinion-filter_dropdown_0'));
      await tester.tap(filter_0, warnIfMissed: false);
      await tester.pump();
    });

    testWidgets('select filter 1 stars', (WidgetTester tester) async {
      final testPage = initPage(const OpinionPage(itemId: 1));
      await waitForLoader(tester: tester, testPage: testPage);

      // Replace these keys with the actual keys used in your RentArticlePage UI
      Finder opinionTitleFinder = find.byKey(const Key('opinion-title'));
      Finder addOpinionButtonFinder =
          find.byKey(const Key('add_opinion-button'));
      Finder opinionButtonFilterFinder =
          find.byKey(const Key('opinion-filter_dropdown'));

      // Verify the initial state
      expect(opinionTitleFinder, findsOneWidget);
      expect(addOpinionButtonFinder, findsOneWidget);
      expect(opinionButtonFilterFinder, findsOneWidget);

      await tester.tap(opinionButtonFilterFinder, warnIfMissed: false);
      await tester.pump();

      Finder filterAll = find.byKey(const Key('opinion-filter_dropdown_all'));
      await tester.tap(filterAll, warnIfMissed: false);
      await tester.pump();

      Finder filter_1 = find.byKey(const Key('opinion-filter_dropdown_1'));
      await tester.tap(filter_1, warnIfMissed: false);
      await tester.pump();
    });

    testWidgets('select filter 2 stars', (WidgetTester tester) async {
      final testPage = initPage(const OpinionPage(itemId: 1));
      await waitForLoader(tester: tester, testPage: testPage);

      // Replace these keys with the actual keys used in your RentArticlePage UI
      Finder opinionTitleFinder = find.byKey(const Key('opinion-title'));
      Finder addOpinionButtonFinder =
          find.byKey(const Key('add_opinion-button'));
      Finder opinionButtonFilterFinder =
          find.byKey(const Key('opinion-filter_dropdown'));

      // Verify the initial state
      expect(opinionTitleFinder, findsOneWidget);
      expect(addOpinionButtonFinder, findsOneWidget);
      expect(opinionButtonFilterFinder, findsOneWidget);

      await tester.tap(opinionButtonFilterFinder, warnIfMissed: false);
      await tester.pump();

      Finder filterAll = find.byKey(const Key('opinion-filter_dropdown_all'));
      await tester.tap(filterAll, warnIfMissed: false);
      await tester.pump();

      Finder filter_2 = find.byKey(const Key('opinion-filter_dropdown_2'));
      await tester.tap(filter_2, warnIfMissed: false);
      await tester.pump();
    });

    testWidgets('select filter 3 stars', (WidgetTester tester) async {
      final testPage = initPage(const OpinionPage(itemId: 1));
      await waitForLoader(tester: tester, testPage: testPage);

      // Replace these keys with the actual keys used in your RentArticlePage UI
      Finder opinionTitleFinder = find.byKey(const Key('opinion-title'));
      Finder addOpinionButtonFinder =
          find.byKey(const Key('add_opinion-button'));
      Finder opinionButtonFilterFinder =
          find.byKey(const Key('opinion-filter_dropdown'));

      // Verify the initial state
      expect(opinionTitleFinder, findsOneWidget);
      expect(addOpinionButtonFinder, findsOneWidget);
      expect(opinionButtonFilterFinder, findsOneWidget);

      await tester.tap(opinionButtonFilterFinder, warnIfMissed: false);
      await tester.pump();

      Finder filterAll = find.byKey(const Key('opinion-filter_dropdown_all'));
      await tester.tap(filterAll, warnIfMissed: false);
      await tester.pump();

      Finder filter_3 = find.byKey(const Key('opinion-filter_dropdown_3'));
      await tester.tap(filter_3, warnIfMissed: false);
      await tester.pump();
    });

    testWidgets('select filter 4 stars', (WidgetTester tester) async {
      final testPage = initPage(const OpinionPage(itemId: 1));
      await waitForLoader(tester: tester, testPage: testPage);

      // Replace these keys with the actual keys used in your RentArticlePage UI
      Finder opinionTitleFinder = find.byKey(const Key('opinion-title'));
      Finder addOpinionButtonFinder =
          find.byKey(const Key('add_opinion-button'));
      Finder opinionButtonFilterFinder =
          find.byKey(const Key('opinion-filter_dropdown'));

      // Verify the initial state
      expect(opinionTitleFinder, findsOneWidget);
      expect(addOpinionButtonFinder, findsOneWidget);
      expect(opinionButtonFilterFinder, findsOneWidget);

      await tester.tap(opinionButtonFilterFinder, warnIfMissed: false);
      await tester.pump();

      Finder filterAll = find.byKey(const Key('opinion-filter_dropdown_all'));
      await tester.tap(filterAll, warnIfMissed: false);
      await tester.pump();

      Finder filter_4 = find.byKey(const Key('opinion-filter_dropdown_4'));
      await tester.tap(filter_4, warnIfMissed: false);
      await tester.pump();
    });

    testWidgets('select filter 5 stars', (WidgetTester tester) async {
      final testPage = initPage(const OpinionPage(itemId: 1));
      await waitForLoader(tester: tester, testPage: testPage);

      // Replace these keys with the actual keys used in your RentArticlePage UI
      Finder opinionTitleFinder = find.byKey(const Key('opinion-title'));
      Finder addOpinionButtonFinder =
          find.byKey(const Key('add_opinion-button'));
      Finder opinionButtonFilterFinder =
          find.byKey(const Key('opinion-filter_dropdown'));

      // Verify the initial state
      expect(opinionTitleFinder, findsOneWidget);
      expect(addOpinionButtonFinder, findsOneWidget);
      expect(opinionButtonFilterFinder, findsOneWidget);

      await tester.tap(opinionButtonFilterFinder, warnIfMissed: false);
      await tester.pump();

      Finder filterAll = find.byKey(const Key('opinion-filter_dropdown_all'));
      await tester.tap(filterAll, warnIfMissed: false);
      await tester.pump();

      Finder filter_5 = find.byKey(const Key('opinion-filter_dropdown_5'));
      await tester.tap(filter_5, warnIfMissed: false);
      await tester.pump();
    });

    testWidgets('no opinion', (WidgetTester tester) async {
      final testPage = initPage(const OpinionPage(itemId: 1));
      await tester.pumpWidget(testPage);
      BuildContext context = tester.element(find.byType(OpinionPage));

      while (true) {
        try {
          expect(find.byType(CircularProgressIndicator), findsOneWidget);
          await tester.pumpWidget(testPage, const Duration(milliseconds: 100));
        } catch (e) {
          break;
        }
      }

      // Replace these keys with the actual keys used in your RentArticlePage UI
      Finder opinionTitleFinder = find.byKey(const Key('opinion-title'));
      Finder addOpinionButtonFinder =
          find.byKey(const Key('add_opinion-button'));
      Finder opinionButtonFilterFinder =
          find.byKey(const Key('opinion-filter_dropdown'));

      // Verify the initial state
      expect(opinionTitleFinder, findsOneWidget);
      expect(addOpinionButtonFinder, findsOneWidget);
      expect(opinionButtonFilterFinder, findsOneWidget);

      await tester.tap(opinionButtonFilterFinder, warnIfMissed: false);
      await tester.pump();

      Finder filterAll = find.byKey(const Key('opinion-filter_dropdown_all'));
      await tester.tap(filterAll, warnIfMissed: false);
      await tester.pump();

      Finder filter_3 = find.byKey(const Key('opinion-filter_dropdown_3'));
      await tester.tap(filter_3, warnIfMissed: false);
      await tester.pump();

      expect(find.text(AppLocalizations.of(context)!.reviewsEmpty),
          findsOneWidget);
    });

    testWidgets('cancel button new opinion', (WidgetTester tester) async {
      final testPage = initPage(const OpinionPage(itemId: 1));
      await waitForLoader(tester: tester, testPage: testPage);

      Finder opinionTitleFinder = find.byKey(const Key('opinion-title'));
      Finder addOpinionButtonFinder =
          find.byKey(const Key('add_opinion-button'));

      expect(opinionTitleFinder, findsOneWidget);
      expect(addOpinionButtonFinder, findsOneWidget);

      Finder filterAll = find.byKey(const Key('opinion-filter_dropdown_all'));

      await tester.tap(filterAll, warnIfMissed: false);
      await tester.pump();

      await tester.tap(addOpinionButtonFinder, warnIfMissed: false);
      await tester.pump();
    });
  });
}
