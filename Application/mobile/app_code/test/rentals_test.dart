import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:risu/components/alert_dialog.dart';
import 'package:risu/pages/rental/rental_page.dart';
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
}
