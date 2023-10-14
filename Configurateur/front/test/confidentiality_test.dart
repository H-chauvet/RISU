import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front/screens/confidentiality/confidentiality.dart';

void main() {
  testWidgets('ConfidentialityPage widget test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ConfidentialityPage(),
      ),
    );

    await tester.pump();
    expect(find.text('Dernière mise à jour : 14 Octobre 2023\n\n'),
        findsOneWidget);
    expect(find.text('Informations que nous collectons'), findsOneWidget);
    expect(
        find.text('Comment nous utilisons vos informations'), findsOneWidget);
  });
}
