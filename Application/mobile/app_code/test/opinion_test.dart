import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:risu/pages/opinion/opinion_page.dart';

import 'globals.dart';

void main() {
  group('Test Opinion Page', () {
    testWidgets('find opinions pages buttons', (WidgetTester tester) async {
      var aaaa = initPage(const OpinionPage());
      await tester.pumpWidget(aaaa);

      while (true) {
        try {
          expect(find.byType(CircularProgressIndicator), findsOneWidget);
          await tester.pumpWidget(aaaa, const Duration(milliseconds: 100));
        } catch (e) {
          break;
        }
      }

      Finder addOpinionButtonFinder =
          find.byKey(const Key('add_opinion-button'));
      Finder opinionButtonFilterFinder = find.text("Tous les avis");

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

      await tester.tap(addOpinionButtonFinder);
      await tester.pump(const Duration(milliseconds: 4000));

      expect(find.text('Ajouter un avis'), findsOneWidget);
      expect(find.byKey(const Key('opinion-star_0')), findsOneWidget);
      expect(find.byKey(const Key('opinion-star_1')), findsOneWidget);
      expect(find.byKey(const Key('opinion-star_2')), findsOneWidget);
      expect(find.byKey(const Key('opinion-star_3')), findsOneWidget);
      expect(find.byKey(const Key('opinion-star_4')), findsOneWidget);

      await tester.tap(find.byKey(const Key('opinion-star_4')));
      await tester.pump();
    });

    testWidgets('select filter 0 stars', (WidgetTester tester) async {
      var aaaa = initPage(const OpinionPage());
      await tester.pumpWidget(aaaa);

      while (true) {
        try {
          expect(find.byType(CircularProgressIndicator), findsOneWidget);
          await tester.pumpWidget(aaaa, const Duration(milliseconds: 100));
        } catch (e) {
          break;
        }
      }

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

      expect(find.text('0 étoile'), findsOneWidget);
      expect(find.text('1 étoile'), findsOneWidget);
      expect(find.text('2 étoiles'), findsOneWidget);
      expect(find.text('3 étoiles'), findsOneWidget);
      expect(find.text('4 étoiles'), findsOneWidget);
      expect(find.text('5 étoiles'), findsOneWidget);
      expect(find.text('Tous les avis'), findsNWidgets(2));

      Finder filter_0 = find.byKey(const Key('opinion-filter_dropdown_0'));
      await tester.tap(filter_0, warnIfMissed: false);
      await tester.pump();
    });

    testWidgets('select filter 1 stars', (WidgetTester tester) async {
      var aaaa = initPage(const OpinionPage());
      await tester.pumpWidget(aaaa);

      while (true) {
        try {
          expect(find.byType(CircularProgressIndicator), findsOneWidget);
          await tester.pumpWidget(aaaa, const Duration(milliseconds: 100));
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

      Finder filter_1 = find.byKey(const Key('opinion-filter_dropdown_1'));
      await tester.tap(filter_1, warnIfMissed: false);
      await tester.pump();
    });

    testWidgets('select filter 2 stars', (WidgetTester tester) async {
      var aaaa = initPage(const OpinionPage());
      await tester.pumpWidget(aaaa);

      while (true) {
        try {
          expect(find.byType(CircularProgressIndicator), findsOneWidget);
          await tester.pumpWidget(aaaa, const Duration(milliseconds: 100));
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

      Finder filter_2 = find.byKey(const Key('opinion-filter_dropdown_2'));
      await tester.tap(filter_2, warnIfMissed: false);
      await tester.pump();
    });

    testWidgets('select filter 3 stars', (WidgetTester tester) async {
      var aaaa = initPage(const OpinionPage());
      await tester.pumpWidget(aaaa);

      while (true) {
        try {
          expect(find.byType(CircularProgressIndicator), findsOneWidget);
          await tester.pumpWidget(aaaa, const Duration(milliseconds: 100));
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
    });

    testWidgets('select filter 4 stars', (WidgetTester tester) async {
      var aaaa = initPage(const OpinionPage());
      await tester.pumpWidget(aaaa);

      while (true) {
        try {
          expect(find.byType(CircularProgressIndicator), findsOneWidget);
          await tester.pumpWidget(aaaa, const Duration(milliseconds: 100));
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

      Finder filter_4 = find.byKey(const Key('opinion-filter_dropdown_4'));
      await tester.tap(filter_4, warnIfMissed: false);
      await tester.pump();
    });

    testWidgets('select filter 5 stars', (WidgetTester tester) async {
      var aaaa = initPage(const OpinionPage());
      await tester.pumpWidget(aaaa);

      while (true) {
        try {
          expect(find.byType(CircularProgressIndicator), findsOneWidget);
          await tester.pumpWidget(aaaa, const Duration(milliseconds: 100));
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

      Finder filter_5 = find.byKey(const Key('opinion-filter_dropdown_5'));
      await tester.tap(filter_5, warnIfMissed: false);
      await tester.pump();
    });

    testWidgets('no opinion', (WidgetTester tester) async {
      var aaaa = initPage(const OpinionPage());
      await tester.pumpWidget(aaaa);

      while (true) {
        try {
          expect(find.byType(CircularProgressIndicator), findsOneWidget);
          await tester.pumpWidget(aaaa, const Duration(milliseconds: 100));
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

      expect(find.text('Aucun avis'), findsOneWidget);
    });

    testWidgets('new opinion', (WidgetTester tester) async {
      var aaaa = initPage(const OpinionPage());
      await tester.pumpWidget(aaaa);

      while (true) {
        try {
          expect(find.byType(CircularProgressIndicator), findsOneWidget);
          await tester.pumpWidget(aaaa, const Duration(milliseconds: 100));
        } catch (e) {
          break;
        }
      }

      Finder addOpinionButtonFinder =
          find.byKey(const Key('add_opinion-button'));
      Finder opinionButtonFilterFinder = find.text("Tous les avis");

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

      await tester.tap(addOpinionButtonFinder);
      await tester.pump(const Duration(milliseconds: 4000));

      expect(find.text('Ajouter un avis'), findsOneWidget);
      expect(find.byKey(const Key('opinion-star_0')), findsOneWidget);
      expect(find.byKey(const Key('opinion-star_1')), findsOneWidget);
      expect(find.byKey(const Key('opinion-star_2')), findsOneWidget);
      expect(find.byKey(const Key('opinion-star_3')), findsOneWidget);
      expect(find.byKey(const Key('opinion-star_4')), findsOneWidget);

      await tester.tap(find.byKey(const Key('opinion-star_0')),
          warnIfMissed: false);
      await tester.pump();
      await tester.tap(find.byKey(const Key('opinion-star_1')),
          warnIfMissed: false);
      await tester.pump();
      await tester.tap(find.byKey(const Key('opinion-star_2')),
          warnIfMissed: false);
      await tester.pump();
      await tester.tap(find.byKey(const Key('opinion-star_3')),
          warnIfMissed: false);
      await tester.pump();
      await tester.tap(find.byKey(const Key('opinion-star_4')),
          warnIfMissed: false);
      await tester.pump();

      await tester.enterText(
          find.byKey(const Key('opinion-textinput_comment')), 'test');

      final buttonFinder = find.byKey(const Key('opinion-button_add'));
      expect(buttonFinder, findsOneWidget);
      await tester.tap(buttonFinder, warnIfMissed: false);
      await tester.pump();
    });

    testWidgets('cancel button new opinion', (WidgetTester tester) async {
      var aaaa = initPage(const OpinionPage());
      await tester.pumpWidget(aaaa);

      while (true) {
        try {
          expect(find.byType(CircularProgressIndicator), findsOneWidget);
          await tester.pumpWidget(aaaa, const Duration(milliseconds: 100));
        } catch (e) {
          break;
        }
      }

      // Replace these keys with the actual keys used in your RentArticlePage UI
      Finder opinionTitleFinder = find.byKey(const Key('opinion-title'));
      Finder addOpinionButtonFinder =
          find.byKey(const Key('add_opinion-button'));

      // Verify the initial state
      expect(opinionTitleFinder, findsOneWidget);
      expect(addOpinionButtonFinder, findsOneWidget);

      Finder filterAll = find.byKey(const Key('opinion-filter_dropdown_all'));

      await tester.tap(filterAll, warnIfMissed: false);
      await tester.pump();

      await tester.tap(addOpinionButtonFinder, warnIfMissed: false);
      await tester.pump();

      final buttonFinder = find.byKey(const Key('cancel-button'));
      expect(buttonFinder, findsOneWidget);
      await tester.tap(buttonFinder, warnIfMissed: false);
      await tester.pump();
    });
  });
}
