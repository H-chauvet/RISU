import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:front/screens/container-creation/container_creation.dart';
import 'package:front/services/storage_service.dart';

void main() {
  testWidgets('Container Creation progress bar', (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(5000, 5000);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    token = "token";

    await tester.pumpWidget(const MaterialApp(
      home: ContainerCreation(),
    ));

    expect(find.text('Précédent'), findsOneWidget);
    expect(find.text('Terminer'), findsOneWidget);
  });

  testWidgets('Container Creation progress bar 2', (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(5000, 5000);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    token = "token";

    await tester.pumpWidget(const MaterialApp(
      home: ContainerCreation(),
    ));

    await tester.pump();

    await tester.tap(find.byKey(const Key('terminate')));
  });

  testWidgets('Container Creation progress bar 3', (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(5000, 5000);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    token = "token";

    await tester.pumpWidget(const MaterialApp(
      home: ContainerCreation(),
    ));

    await tester.pump();

    await tester.tap(find.byKey(const Key('previous')));
  });

  testWidgets('Container Creation back view panel from front',
      (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(5000, 5000);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    token = "token";

    await tester.pumpWidget(const MaterialApp(
      home: ContainerCreation(),
    ));

    await tester.pump();

    await tester.tap(find.byKey(const Key('back-view')));
  });

  testWidgets('Container Creation back view panel from left',
      (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(5000, 5000);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    token = "token";

    await tester.pumpWidget(const MaterialApp(
      home: ContainerCreation(),
    ));

    await tester.pump();

    await tester.tap(find.byKey(const Key('left-view')));
    await tester.tap(find.byKey(const Key('back-view')));
    await tester.tap(find.byKey(const Key('right-view')));
    await tester.tap(find.byKey(const Key('front-view')));
  });

  testWidgets('Container Creation back view panel 2',
      (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(5000, 5000);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    token = "token";

    await tester.pumpWidget(const MaterialApp(
      home: ContainerCreation(),
    ));

    await tester.pump();

    await tester.tap(find.byKey(const Key('right-view')));
    await tester.tap(find.byKey(const Key('back-view')));
    await tester.tap(find.byKey(const Key('front-view')));
    await tester.tap(find.byKey(const Key('left-view')));
  });

  testWidgets('Container Creation back view panel 3',
      (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(5000, 5000);
    tester.binding.window.devicePixelRatioTestValue = 1.0;

    token = "token";

    await tester.pumpWidget(const MaterialApp(
      home: ContainerCreation(),
    ));

    await tester.pump();

    await tester.tap(find.byKey(const Key('back-view')));
    await tester.tap(find.byKey(const Key('left-view')));
    await tester.tap(find.byKey(const Key('right-view')));
    await tester.tap(find.byKey(const Key('left-view')));
    await tester.tap(find.byKey(const Key('front-view')));
  });

  /*testWidgets('updateCube', (WidgetTester tester) async {
    tester.binding.window.physicalSizeTestValue = const Size(5000, 5000);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    await tester.pumpWidget(const MaterialApp(
      home: ContainerCreation(),
    ));

    ContainerCreationState containerCreationState = ContainerCreationState();

    containerCreationState
        .updateCube(LockerCoordinates(1, 2, 'Devant', 'Haut', 1, 'Rouge'));
    containerCreationState
        .updateCube(LockerCoordinates(2, 2, 'Derrière', 'Haut', 2, 'Bleu'));
    containerCreationState
        .updateCube(LockerCoordinates(3, 5, 'Devant', 'Bas', 3, 'Vert'));

    expect(containerCreationState.lockers[0].type, 'Petit casier');
    expect(containerCreationState.lockers[0].price, 50);
    expect(containerCreationState.lockers[1].type, 'Moyen casier');
    expect(containerCreationState.lockers[1].price, 100);
    expect(containerCreationState.lockers[2].type, 'Grand casier');
    expect(containerCreationState.lockers[2].price, 150);
  });*/
}
