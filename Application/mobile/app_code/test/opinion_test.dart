import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:risu/components/alert_dialog.dart';
import 'package:risu/pages/opinion/opinion_page.dart';
import 'package:risu/utils/theme.dart';

void main() {
  group('Test RentArticlePage', () {
    testWidgets('Rent Article Page UI', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<ThemeProvider>(
              create: (_) => ThemeProvider(false),
            ),
          ],
          child: const MaterialApp(
            home: OpinionPage(),
          ),
        ),
      );

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

      await tester.tap(opinionButtonFilterFinder);
      await tester.pump();

      Finder filterAll = find.byKey(const Key('opinion-filter_dropdown_all'));

      await tester.tap(filterAll);
      await tester.pump();

      await tester.tap(addOpinionButtonFinder);
      await tester.pump();

      expect(find.text('Ajouter un avis'), findsOneWidget);
      expect(find.byKey(const Key('opinion-star_0')), findsOneWidget);
      expect(find.byKey(const Key('opinion-star_1')), findsOneWidget);
      expect(find.byKey(const Key('opinion-star_2')), findsOneWidget);
      expect(find.byKey(const Key('opinion-star_3')), findsOneWidget);
      expect(find.byKey(const Key('opinion-star_4')), findsOneWidget);

      await tester.tap(find.byKey(const Key('opinion-star_4')));
      await tester.pump();

      /*await tester.tap(filterAll);
      await tester.pump();

      expect(filterAll, findsOneWidget);*/

/*
      // Simulate user interaction
      await tester.tap(incrementButtonFinder);
      await tester.pump();

      // Verify the updated state after interaction
      expect(find.text('2 heures'), findsOneWidget);

      // Simulate user interaction
      await tester.tap(decrementButtonFinder);
      await tester.pump();

      // Verify the updated state after interaction
      expect(find.text('1 heure'), findsOneWidget);

      // Simulate another user interaction
      await tester.scrollUntilVisible(confirmButtonFinder, 100.0);
      await tester.tap(confirmButtonFinder);
      await tester.pump();

      // Verify that the confirmation dialog appears
      expect(find.text('Confirmer la location'), findsOneWidget);

      // Simulate confirming the rent
      await tester.tap(find.text('Confirmer'));
      await tester.pump();

      // Verify the expected behavior after confirming rent
      // Add assertions based on your implementation

 */
    });
  });
}
