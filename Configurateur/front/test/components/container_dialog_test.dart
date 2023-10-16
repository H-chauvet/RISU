import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:front/components/container_dialog.dart';
import 'package:front/services/locker_service.dart';

void main() {
  void blankFunction(LockerCoordinates coordinates) {}

  testWidgets('test unfilled form', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: ContainerDialog(
      callback: blankFunction,
      size: 1,
    )));

    await tester.tap(find.text('Ajouter'));
    await tester.pump();

    expect(find.text('Veuillez remplir ce champ'), findsWidgets);
  });

  testWidgets('test invalid position form', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: ContainerDialog(
      callback: blankFunction,
      size: 1,
    )));

    await tester.enterText(find.byType(TextFormField).at(0), '13');

    await tester.tap(find.text('Ajouter'));
    await tester.pump();

    expect(find.text('Veuillez remplir ce champ'), findsOneWidget);
    expect(find.text('Position invalide'), findsOneWidget);
  });

  testWidgets('test invalid position form 2', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
        home: ContainerDialog(
      callback: blankFunction,
      size: 1,
    )));

    await tester.enterText(find.byType(TextFormField).at(1), '6');

    await tester.tap(find.text('Ajouter'));
    await tester.pump();

    expect(find.text('Veuillez remplir ce champ'), findsOneWidget);
    expect(find.text('Position invalide'), findsOneWidget);
  });
}
