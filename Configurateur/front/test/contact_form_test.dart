import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front/screens/contact/contact.dart';

void main() {
  testWidgets('no data', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1920, 1080));

    await tester.pumpWidget(const MaterialApp(home: ContactPage()));

    await tester.tap(find.text('Envoyer'));
    await tester.pump();

    expect(find.text('Veuillez entrer votre prénom'), findsOneWidget);
    expect(find.text('Veuillez entrer votre nom'), findsOneWidget);
    expect(find.text('Veuillez entrer votre email'), findsOneWidget);
    expect(find.text('Veuillez entrer votre message'), findsOneWidget);
    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('correct data', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1920, 1080));
    await tester.pumpWidget(const MaterialApp(home: ContactPage()));

    await tester.enterText(find.byType(TextFormField).at(0), 'TestPrénom');
    await tester.enterText(find.byType(TextFormField).at(1), 'TestNom');
    await tester.enterText(find.byType(TextFormField).at(2), 'test@test.com');
    await tester.enterText(find.byType(TextFormField).at(3), 'TestMessage');
    await tester.tap(find.text('Envoyer'));
    await tester.pump();

    expect(find.text('Veuillez entrer un email valide'), findsNothing);
    expect(find.text('Veuillez entrer votre prénom'), findsNothing);
    expect(find.text('Veuillez entrer votre nom'), findsNothing);
    expect(find.text('Veuillez entrer votre message'), findsNothing);
    await tester.binding.setSurfaceSize(null);
  });

  testWidgets('correct data bis', (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1920, 1080));
    await tester.pumpWidget(MaterialApp(home: ContactPage()));

    await tester.enterText(find.byType(TextFormField).at(0), 'TestPrénom');
    await tester.enterText(find.byType(TextFormField).at(1), 'TestNom');
    await tester.enterText(find.byType(TextFormField).at(2), 'test@tes');
    await tester.enterText(find.byType(TextFormField).at(3), 'TestMessage');
    await tester.tap(find.text('Envoyer'));
    await tester.pump();

    expect(find.text('Veuillez entrer un email valide'), findsOneWidget);
    expect(find.text('Veuillez entrer votre prénom'), findsNothing);
    expect(find.text('Veuillez entrer votre nom'), findsNothing);
    expect(find.text('Veuillez entrer votre message'), findsNothing);
    await tester.binding.setSurfaceSize(null);
  });
}
