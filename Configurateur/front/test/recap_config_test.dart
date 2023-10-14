import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front/screens/recap-config/recap_config.dart';

void main() {
  testWidgets('Recap config test', (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(5000, 5000);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    await tester.pumpWidget(const MaterialApp(
      home: RecapConfigPage(),
    ));

    expect(find.text('Récapitulatif de commande'), findsOneWidget);
    expect(find.text('Nom du produit:'), findsOneWidget);
    expect(find.text('Conteneur classique'), findsOneWidget);
    expect(find.text('Options:'), findsOneWidget);
    expect(find.text('Flocage(Oui) - Logo(Oui) - Couleur personnalisée(Non)'),
        findsOneWidget);
    expect(find.text('Taille:'), findsOneWidget);
    expect(find.text('8m x 4.50m x 2.50m'), findsOneWidget);
    expect(find.text('Prix:'), findsOneWidget);
    expect(find.text('6500.00 €'), findsOneWidget);
    expect(find.text('Retour'), findsOneWidget);
    expect(find.text('Payer'), findsOneWidget);

    await tester.tap(find.text('Payer'));
    await tester.pump();
  });
}
