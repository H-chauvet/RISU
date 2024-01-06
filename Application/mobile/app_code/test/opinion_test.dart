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
    });
  });
}