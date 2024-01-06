import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:risu/components/alert_dialog.dart';
import 'package:risu/pages/rental/rental_page.dart';
import 'package:risu/utils/theme.dart';

void main() {
  group('Test RentalPage', () {
    testWidgets('Rental Page UI', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<ThemeProvider>(
              create: (_) => ThemeProvider(false),
            ),
          ],
          child: const MaterialApp(
            home: RentalPage(),
          ),
        ),
      );

      // Test de la présence du titre 'Mes locations'
      expect(find.text('Mes locations'), findsOneWidget);

      // Test de la présence des boutons 'Toutes' et 'En cours'
      expect(find.text('Toutes'), findsOneWidget);
      expect(find.text('En cours'), findsOneWidget);
    });
  });
  testWidgets('Rentals, Test if buttons are clickable', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeProvider>(
            create: (_) => ThemeProvider(false),
          ),
        ],
        child: const MaterialApp(
          home: RentalPage(),
        ),
      ),
    );

    // Verify initial state
    expect(find.text('Toutes'), findsOneWidget);
    expect(find.text('En cours'), findsOneWidget);

    // Tap on the 'Toutes' button
    await tester.tap(find.text('Toutes'));
    await tester.pump();

    // Verify the updated state
    expect(find.text('Toutes'), findsOneWidget);
    expect(find.text('En cours'), findsOneWidget);

    // Tap on the 'En cours' button
    await tester.tap(find.text('En cours'));
    await tester.pump();

    // Verify the updated state
    expect(find.text('Toutes'), findsOneWidget);
    expect(find.text('En cours'), findsOneWidget);
  });
  testWidgets('Rental 1', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<ThemeProvider>(
            create: (_) => ThemeProvider(false),
          ),
        ],
        child: const MaterialApp(
          home: RentalPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // expect List of rentals to be displayed
    expect(find.byKey(const Key('rentals-list')), findsOneWidget);
  });

}
