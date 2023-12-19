import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:risu/components/alert_dialog.dart';
import 'package:risu/pages/article/rent_page.dart';
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
            home: RentArticlePage(
              name: 'Ballon de volley',
              price: 2,
              containerId: 1,
              locations: ['Gymnase', 'Salle de sport'],
            ),
          ),
        ),
      );

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
    });
  });
}