import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front/screens/contact/contact.dart';

void main() {
  testWidgets('no data', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ContactPage()));

    await tester.tap(find.text('Envoyer'));
    await tester.pump();

    expect(find.text('Veuillez entrer votre nom et prénom'), findsOneWidget);
    expect(find.text('Veuillez entrer votre email'), findsOneWidget);
    expect(find.text('Veuillez entrer votre message'), findsOneWidget);
  });

  testWidgets('correct data', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: ContactPage()));

    await tester.enterText(find.byType(TextFormField).first, 'test');
    await tester.enterText(find.byType(TextFormField).last, 'test@test.test');
    await tester.enterText(find.byType(TextFormField).last, 'test');
    await tester.tap(find.text('Envoyer'));
    await tester.pump();

    expect(find.text('Veuillez entrer un email valide'), findsNothing);
  });
}