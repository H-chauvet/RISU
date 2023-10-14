import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front/screens/landing-page/landing_page.dart';

void main() {
  testWidgets('Test de LandingPage', (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(5000, 5000);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    await tester.pumpWidget(const MaterialApp(
      home: LandingPage(),
    ));

    expect(
        find.text(
            'Trouvez des locations selon vos \rbesoins, où vous les souhaitez'),
        findsOneWidget);
    expect(find.text('Des conteneurs disponibles partout en france !'),
        findsOneWidget);
    expect(find.text('En savoir plus'), findsOneWidget);

    await tester.tap(find.text('En savoir plus'));
    await tester.pump();
  });
}
