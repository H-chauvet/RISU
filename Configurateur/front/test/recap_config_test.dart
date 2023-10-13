import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front/screens/recap-config/recap_config.dart';

void main() {
  testWidgets('Recap Config', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(
      home: RecapConfigPage(),
    ));

    await tester.pump();

    expect(find.text('Récapitulatif de commande'), findsOneWidget);
    expect(find.text('Nom du produit:'), findsOneWidget);
    expect(find.text('Options:'), findsOneWidget);
    expect(find.text('Taille:'), findsOneWidget);
    expect(find.text('Prix:'), findsOneWidget);

    final containerImageFinder = find.byWidgetPredicate((widget) {
      if (widget is Image) {
        final Image image = widget;
        return image.image is AssetImage &&
            (image.image as AssetImage).assetName == 'assets/container.png';
      }
      return false;
    });
    expect(containerImageFinder, findsOneWidget);
  });
}
